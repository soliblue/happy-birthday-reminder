import WidgetKit
import SwiftUI
import Contacts

struct Provider: TimelineProvider {
    func fetchUpcomingBirthdays(limit: Int) -> [CNContact] {
        let store = CNContactStore()
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor, CNContactNicknameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactBirthdayKey as CNKeyDescriptor
        ]
        guard let contacts = try? store.unifiedContacts(matching: CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier()), keysToFetch: keysToFetch) else {
            return []
        }
        let contactsWithBirthdays = contacts.filter { contact in
            return contact.birthday != nil
        }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let sortedContactsWithBirthdays = contactsWithBirthdays.sorted {
            guard let birthday1 = $0.birthday?.date, let birthday2 = $1.birthday?.date else { return false }
            
            let todayComponents = calendar.dateComponents([.month, .day], from: today)
            let birthday1Components = calendar.dateComponents([.month, .day], from: birthday1)
            let birthday2Components = calendar.dateComponents([.month, .day], from: birthday2)
            
            if birthday1Components == todayComponents && birthday2Components != todayComponents {
                return true
            } else if birthday2Components == todayComponents && birthday1Components != todayComponents {
                return false
            }

            let nextBirthday1 = calendar.nextDate(after: today, matching: birthday1Components, matchingPolicy: .nextTimePreservingSmallerComponents)!
            let nextBirthday2 = calendar.nextDate(after: today, matching: birthday2Components, matchingPolicy: .nextTimePreservingSmallerComponents)!

            return nextBirthday1 < nextBirthday2
        }

        return Array(sortedContactsWithBirthdays.prefix(limit))
    }
    
    
    
    func placeholder(in context: Context) -> BirthdayEntry {
        BirthdayEntry(date: Date(), upcomingBirthdays: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BirthdayEntry) -> ()) {
        let upcomingBirthdays = fetchUpcomingBirthdays(limit:3)
        let entry = BirthdayEntry(date: Date(), upcomingBirthdays: upcomingBirthdays)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BirthdayEntry>) -> ()) {
        let upcomingBirthdays = fetchUpcomingBirthdays(limit:3)
        let entry = BirthdayEntry(date: Date(), upcomingBirthdays: upcomingBirthdays)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
