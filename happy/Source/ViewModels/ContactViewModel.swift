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
    @Published var accessDenied: Bool = false
    @Published var contacts: [CNContact] = []
    @Published var searchText: String = ""
    
    static let birthdayNotificationIdentifier = "BirthdayNotification"
    
    private let contactsService = ContactService()
    private let notificationsService = NotificationService()
    
    init() {
        fetchContacts()
    }
    
    var monthSections: [MonthInfo: [CNContact]] {
        let contactsWithBirthday = filteredContacts().filter { $0.nextBirthday != nil }
        
        let sortedContactsWithBirthday = contactsWithBirthday.sorted {
            let date1 = $0.nextBirthday!
            let date2 = $1.nextBirthday!
            let day1 = Calendar.current.component(.day, from: date1)
            let day2 = Calendar.current.component(.day, from: date2)
            return day1 < day2 || (day1 == day2 && date1 < date2)
        }
        
        return Dictionary(grouping: sortedContactsWithBirthday, by: {
            MonthInfo(number: Calendar.current.component(.month, from: $0.nextBirthday!), name: $0.nextBirthday!.month)
        })
    }
    
    func fetchContacts() {
        self.contactsService.fetchContacts { accessGranted, contacts in
            DispatchQueue.main.async {
                if accessGranted {
                    self.contacts = contacts
                    self.scheduleUpcomingBirthdays(for: contacts)
                } else {
                    self.accessDenied = true
                }
            }
        }
    }
    
    func updateBirthday(for contact: CNContact, with: Date? = nil) {
        self.contactsService.updateBirthday(for: contact, with: with){ success in
            if success {
                self.fetchContacts()
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
