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
    
    func fetchContacts(completion: @escaping (Bool, [CNContact]) -> Void) {
        self.requestAccess { granted in
            if granted {
                let requiredKeys = CNContactViewController.descriptorForRequiredKeys()
                let keysToFetch: [CNKeyDescriptor] = [requiredKeys]
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: self.store.defaultContainerIdentifier())
                do {
                    let contacts = try self.store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                    completion(true,contacts)
                } catch {
                    print("Failed to fetch contacts:", error)
                    completion(true,[])
                }
            } else {
                completion(false,[])
            }
        }
    }
    
    
    func updateBirthday(for contact: CNContact, with date: Date? = nil, completion: @escaping (Bool) -> Void) {
        requestAccess { granted in
            if granted {
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                mutableContact.birthday = date != nil ? Calendar.current.dateComponents([.year, .month, .day], from: date!) : nil
                
                let saveRequest = CNSaveRequest()
                saveRequest.update(mutableContact)
                
                do {
                    try self.store.execute(saveRequest)
                    completion(true)
                } catch {
                    print("Failed to update birthday:", error)
                    completion(false)
                }
            } else {
                print("Access to contacts was denied or restricted.")
            }
        }
    }
}
