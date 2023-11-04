import WidgetKit
import SwiftUI
import Contacts

struct Provider: TimelineProvider {
    func fetchUpcomingBirthdays(limit: Int) -> [CNContact] {
        let store = CNContactStore()
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor, CNContactNicknameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactBirthdayKey as CNKeyDescriptor
        ]
        // Attempt to fetch contacts from the default container
        guard let contacts = try? store.unifiedContacts(matching: CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier()), keysToFetch: keysToFetch) else {
            return []
        }
        
        // Prepare the calendar and current date
        let calendar = Calendar.current
        let currentDate = Date()
        let startOfDay = calendar.startOfDay(for: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        let cutoffDate = calendar.date(byAdding: .day, value: 14, to: startOfDay)!

        // Filter and map contacts with upcoming birthdays
        let upcomingBirthdays = contacts.compactMap { contact -> CNContact? in
            guard let birthday = contact.birthday,
                  let birthMonth = birthday.month,
                  let birthDay = birthday.day,
                  let thisYearBirthday = calendar.date(from: DateComponents(year: currentYear, month: birthMonth, day: birthDay))
            else {
                return nil
            }
            
            // Check if this year's birthday is upcoming or if it is today
            if thisYearBirthday >= startOfDay && thisYearBirthday <= cutoffDate {
                return contact
            } else if thisYearBirthday < startOfDay {
                // Check if the birthday next year is within the next 14 days
                if let nextYearBirthday = calendar.date(byAdding: .year, value: 1, to: thisYearBirthday), nextYearBirthday <= cutoffDate {
                    return contact
                }
            }
            return nil
        }.sorted { // Sort the contacts by the upcoming birthday dates
            guard let bday1 = $0.birthday, let bday2 = $1.birthday else { return false }
            let date1 = calendar.date(from: DateComponents(year: currentYear, month: bday1.month, day: bday1.day))!
            let date2 = calendar.date(from: DateComponents(year: currentYear, month: bday2.month, day: bday2.day))!
            return date1 < date2
        }
        
        // Return the contacts up to the specified limit
        return Array(upcomingBirthdays.prefix(limit))
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
