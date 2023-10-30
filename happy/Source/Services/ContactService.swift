import CoreData
import Contacts
import ContactsUI


class ContactService {
    private let store = CNContactStore()
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                completion(granted)
            }
        default:
            completion(false)
        }
    }
    
    func fetchContacts(completion: @escaping ([CNContact]) -> Void) {
            let requiredKeys = CNContactViewController.descriptorForRequiredKeys()
            let keysToFetch: [CNKeyDescriptor] = [requiredKeys]
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
            do {
                let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                
                // Linking with CoreData
                let context = CoreDataStack.shared.context
                for cnContact in contacts {
                    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "identifier = %@", cnContact.identifier)
                    do {
                        let matchingContacts = try context.fetch(fetchRequest)
                        if let coreDataContact = matchingContacts.first {
                            // Link existing CoreData contact to CNContact
                            cnContact.coreData = coreDataContact
                        } else {
                            // Create new CoreData contact and link it to CNContact
                            let newContact = Contact(context: context)
                            newContact.identifier = cnContact.identifier
                            newContact.isFavorite = false
                            cnContact.coreData = newContact
                        }
                    } catch {
                        print("Error fetching CoreData Contact:", error)
                    }
                }
                // Save changes to CoreData
                do {
                    try context.save()
                } catch {
                    print("Error saving context:", error)
                }

                completion(contacts)
            } catch {
                print("Failed to fetch contacts:", error)
                completion([])
            }
        }

    
    func updateBirthday(for contact: CNContact, with date: Date, completion: @escaping (Bool) -> Void) {
        let mutableContact = contact.mutableCopy() as! CNMutableContact
        mutableContact.birthday = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let saveRequest = CNSaveRequest()
        saveRequest.update(mutableContact)
        do {
            try store.execute(saveRequest)
            completion(true)
        } catch {
            print("Failed to save birthday:", error)
            completion(false)
        }
    }
    
    func clearBirthday(for contact: CNContact, completion: @escaping (Bool) -> Void) {
        // Create a mutable copy of the contact
        let mutableContact = contact.mutableCopy() as! CNMutableContact
        
        // Set the birthday to nil
        mutableContact.birthday = nil
        
        // Create a save request to update the contact
        let saveRequest = CNSaveRequest()
        saveRequest.update(mutableContact)
        
        do {
            // Execute the save request
            try store.execute(saveRequest)
            completion(true)
        } catch {
            print("Failed to clear birthday:", error)
            completion(false)
        }
    }
    
    func toggleIsFavorite(for contact: CNContact, completion: @escaping (Bool) -> Void) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier = %@", contact.identifier)
        
        do {
            let matchingContacts = try context.fetch(fetchRequest)
            if let coreDataContact = matchingContacts.first {
                // Toggle isFavorite property
                coreDataContact.isFavorite.toggle()
                
                // Save changes to CoreData
                try context.save()
                completion(true)
            } else {
                print("No matching CoreData contact found for identifier: \(contact.identifier)")
                completion(false)
            }
        } catch {
            print("Error toggling favorite status or saving context:", error)
            completion(false)
        }
    }


}
