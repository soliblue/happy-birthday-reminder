import SwiftUI
import Contacts
import Foundation

class HumanCreateViewModel: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var searchText: String = ""
    
    private let contactsService = ContactsService()
    
    init() {
        fetchContacts()
    }
    
    private func fetchContacts() {
        contactsService.requestAccess { granted in
            if granted {
                self.contactsService.fetchContacts { contacts in
                    DispatchQueue.main.async {
                        self.contacts = contacts
                    }
                }
            } else {
                print("Access to contacts is denied or restricted")
            }
        }
    }
    
    func updateBirthday(for contact: CNContact, with date: Date) {
        contactsService.updateBirthday(for: contact, with: date) { success in
            if success {
                print("Saved birthday successfully.")
            } else {
                print("Failed to save birthday.")
            }
        }
    }
    
    func filteredContacts() -> [CNContact] {
        let searchWords = searchText.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")

        if searchWords.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                let contactWords = ["\(contact.givenName)", "\(contact.familyName)", "\(contact.nickname)"].joined(separator: " ").split(separator: " ")

                return searchWords.allSatisfy { searchWord in
                    contactWords.contains { contactWord in
                        contactWord.localizedCaseInsensitiveContains(searchWord)
                    }
                }
            }
        }
    }



}
