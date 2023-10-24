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
    
    private let contactsService = ContactsService()
    
    // Group by month
    var monthSections: [MonthInfo: [Human]] {
        Dictionary(grouping: humans, by: { MonthInfo(number: Calendar.current.component(.month, from: $0.nextBirthday), name: $0.nextBirthday.month) })
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
                        let nickname = contact.nickname.isEmpty ? nil : contact.nickname
                        let phoneNumber = contact.phoneNumbers.first?.value.stringValue
                        let email = contact.emailAddresses.first?.value as String?
                        let imageData = (contact.imageDataAvailable ? contact.imageData : nil)
                        
                        return Human(name: name, nickname: nickname, birthdate: date, phoneNumber: phoneNumber, email: email, imageData: imageData)
                    }
                    
                    // Sorting fetchedHumans by nextBirthday's month and day
                    DispatchQueue.main.async {
                        self.humans = fetchedHumans.sorted { human1, human2 in
                            let monthAndDay1 = (Calendar.current.component(.month, from: human1.nextBirthday), Calendar.current.component(.day, from: human1.nextBirthday))
                            let monthAndDay2 = (Calendar.current.component(.month, from: human2.nextBirthday), Calendar.current.component(.day, from: human2.nextBirthday))
                            return monthAndDay1 < monthAndDay2
                        }
                    }
                }
            } else {
                print("Access to contacts is denied or restricted")
            }
        }
    }

}
