import SwiftUI
import Contacts
import Foundation

struct MonthInfo: Comparable, Hashable {
    var number: Int
    var name: String
    
    static func < (lhs: MonthInfo, rhs: MonthInfo) -> Bool {
        return lhs.number < rhs.number
    }
}

class ContactViewModel: ObservableObject {
    @Published var contacts: [CNContact] = []
    @Published var searchText: String = ""
    
    static let birthdayNotificationIdentifier = "BirthdayNotification"
    
    private let contactsService = ContactsService()
    private let notificationsService = NotificationsService()
    
    init() {
        fetchContacts()
    }
    
    var monthSections: [MonthInfo: [CNContact]] {
        let contactsWithBirthday = filteredContacts().filter { $0.nextBirthday != nil }
        return Dictionary(grouping: contactsWithBirthday, by: { MonthInfo(number: Calendar.current.component(.month, from: $0.nextBirthday!), name: $0.nextBirthday!.month) })
    }
    
    
    func fetchContacts() {
        contactsService.requestAccess { granted in
            if granted {
                self.contactsService.fetchContacts { contacts in
                    DispatchQueue.main.async {
                        self.contacts = contacts
                    }
                    self.scheduleUpcomingBirthdays(for: contacts)
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
    
    func scheduleUpcomingBirthdays(for contacts: [CNContact]) {
        // Step 1: Remove all existing birthday notifications
        notificationsService.removeAllNotifications(with: ContactViewModel.birthdayNotificationIdentifier) {
            
            // Step 2: Schedule new notifications for birthdays in the next 30 days
            let upcomingBirthdays = contacts.filter { contact in
                guard let nextBirthday = contact.nextBirthday else { return false }
                let currentDate = Date()
                let dayDifference = Calendar.current.dateComponents([.day], from: currentDate, to: nextBirthday).day!
                return dayDifference > 0 && dayDifference <= 31
            }
            upcomingBirthdays.forEach { contact in
                let title = "\(contact.name)'s Birthday"
                let body = "It's \(contact.name)'s birthday today! 🎉"
                
                if let imageData = contact.thumbnailImageData {
                    self.notificationsService.scheduleNotification(title: title, body: body, categoryIdentifier: ContactViewModel.birthdayNotificationIdentifier, triggerDate: contact.nextBirthday!, imageData: imageData)
                } else {
                    self.notificationsService.scheduleNotification(title: title, body: body, categoryIdentifier: ContactViewModel.birthdayNotificationIdentifier, triggerDate: contact.nextBirthday!)
                }
            }
        }
    }
}
