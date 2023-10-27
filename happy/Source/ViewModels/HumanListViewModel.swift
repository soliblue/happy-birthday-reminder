import Foundation

struct MonthInfo: Comparable, Hashable {
    var number: Int
    var name: String
    
    static func < (lhs: MonthInfo, rhs: MonthInfo) -> Bool {
        return lhs.number < rhs.number
    }
}


class HumanListViewModel: ObservableObject {
    @Published var humans: [Human] = []
    @Published var searchText: String = ""
    private let contactsService = ContactsService()
    private let notificationService = NotificationService()
    static let birthdayNotificationIdentifier = "BirthdayNotification"

    // Group by month
    var monthSections: [MonthInfo: [Human]] {
        Dictionary(grouping: filteredHumans(), by: { MonthInfo(number: Calendar.current.component(.month, from: $0.nextBirthday), name: $0.nextBirthday.month) })
    }
    
    func fetchHumans() {
        contactsService.requestAccess { granted in
            if granted {
                self.contactsService.fetchContacts { contacts in
                    let fetchedHumans = contacts.compactMap { contact -> Human? in
                        guard let birthday = contact.birthday, let date = Calendar.current.date(from: birthday) else {
                            return nil
                        }
                        
                        let name = "\(contact.givenName) \(contact.familyName)"
                        let givenName = contact.givenName.isEmpty ? nil : contact.givenName
                        let familyName = contact.familyName.isEmpty ? nil : contact.familyName
                        let nickname = contact.nickname.isEmpty ? nil : contact.nickname
                        let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                        let email = contact.emailAddresses.first?.value as String?
                        let imageData = (contact.imageDataAvailable ? contact.imageData : nil)
                        
                        return Human(name: name, givenName: givenName, familyName: familyName, nickname: nickname, birthdate: date, phoneNumber: phoneNumber, email: email, imageData: imageData)
                    }
                    
                    DispatchQueue.main.async {
                        self.humans = fetchedHumans.sorted { human1, human2 in
                            let monthAndDay1 = (Calendar.current.component(.month, from: human1.nextBirthday), Calendar.current.component(.day, from: human1.nextBirthday))
                            let monthAndDay2 = (Calendar.current.component(.month, from: human2.nextBirthday), Calendar.current.component(.day, from: human2.nextBirthday))
                            return monthAndDay1 < monthAndDay2
                        }
                        
                        self.scheduleUpcomingBirthdays(for: self.humans)
                    }
                }
            } else {
                print("Access to contacts is denied or restricted")
            }
        }
    }
    
    func scheduleUpcomingBirthdays(for humans: [Human]) {
        // Step 1: Remove all existing birthday notifications
        notificationService.removeAllNotifications(with: HumanListViewModel.birthdayNotificationIdentifier) {
            // Step 2: Schedule new notifications for birthdays in the next 30 days
            let upcomingBirthdays = humans.filter { human in
                let currentDate = Date()
                let nextBirthdayDate = human.nextBirthday
                return Calendar.current.dateComponents([.day], from: currentDate, to: nextBirthdayDate).day! <= 30
            }
            
            upcomingBirthdays.forEach { human in
                let chosenName = human.nickname?.isEmpty == false ? String(describing: human.nickname!) :
                                 (human.givenName?.isEmpty == false ? String(describing: human.givenName!) :
                                  String(describing: human.familyName!))
                                 
                let title = "\(chosenName)'s Birthday"
                let body = "It's \(human.name)'s birthday today! 🎉"


                self.notificationService.scheduleNotification(title: title, body: body,categoryIdentifier: HumanListViewModel.birthdayNotificationIdentifier, triggerDate: human.nextBirthday, imageData: human.imageData)
            }
        }
    }
    
    func filteredHumans() -> [Human] {
        let searchWords = searchText.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ")

        if searchWords.isEmpty {
            return humans
        } else {
            return humans.filter { human in
                let contactWords = ["\(human.givenName)", "\(human.familyName)", "\(human.nickname)"].joined(separator: " ").split(separator: " ")

                return searchWords.allSatisfy { searchWord in
                    contactWords.contains { contactWord in
                        contactWord.localizedCaseInsensitiveContains(searchWord)
                    }
                }
            }
        }
    }
    
}
