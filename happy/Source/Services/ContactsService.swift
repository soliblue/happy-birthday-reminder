import Contacts
import ContactsUI  // Needed for CNContactViewController.descriptorForRequiredKeys()

class ContactsService {
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
}
