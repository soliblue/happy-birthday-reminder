import WidgetKit
import SwiftUI
import Contacts

extension Date {
    
    var longString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
    
    var shortString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        return formatter.string(from: self)
    }
    
    var relativeString: String {
        let calendar = Calendar.current
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let dayDifference = calendar.dateComponents([.day], from: Date(), to: self).day ?? 0
        let adjustedDate = dayDifference > 0 ? calendar.date(byAdding: .day, value: 1, to: self) ?? self : self
        return formatter.localizedString(for: adjustedDate, relativeTo: Date())
    }
}

struct BirthdayEntry: TimelineEntry {
    let date: Date
    let upcomingBirthdays: [CNContact]
}

struct Provider: TimelineProvider {
    func fetchUpcomingBirthdays() -> [CNContact] {
        let store = CNContactStore()
        let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor, CNContactBirthdayKey as CNKeyDescriptor]
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
        let contacts = try? store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        
        let currentDate = Date()
        
        let upcomingBirthdays = contacts?.filter { contact in
            guard let birthday = contact.birthday else { return false }
            
            // Create a birthday date for this year
            var thisYearBirthdayComponents = birthday
            thisYearBirthdayComponents.year = Calendar.current.component(.year, from: currentDate)
            guard let thisYearBirthday = Calendar.current.date(from: thisYearBirthdayComponents) else { return false }
            
            // If the birthday has not occurred this year, check the day difference
            if thisYearBirthday > currentDate {
                let dayDifference = Calendar.current.dateComponents([.day], from: currentDate, to: thisYearBirthday).day!
                return dayDifference <= 14
            } else {
                // Check the birthday for the next year
                var nextYearBirthdayComponents = birthday
                nextYearBirthdayComponents.year = Calendar.current.component(.year, from: currentDate) + 1
                guard let nextYearBirthday = Calendar.current.date(from: nextYearBirthdayComponents) else { return false }
                
                let dayDifference = Calendar.current.dateComponents([.day], from: currentDate, to: nextYearBirthday).day!
                return dayDifference <= 14
            }
        } ?? []
        
        return upcomingBirthdays
    }
    
    
    func placeholder(in context: Context) -> BirthdayEntry {
        BirthdayEntry(date: Date(), upcomingBirthdays: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BirthdayEntry) -> ()) {
        let upcomingBirthdays = fetchUpcomingBirthdays()
        let entry = BirthdayEntry(date: Date(), upcomingBirthdays: upcomingBirthdays)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BirthdayEntry>) -> ()) {
        let upcomingBirthdays = fetchUpcomingBirthdays()
        let entry = BirthdayEntry(date: Date(), upcomingBirthdays: upcomingBirthdays)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct BirthdayWidgetEntryView: View {
    var entry: BirthdayEntry
    func nextBirthday(from dateComponents: DateComponents) -> Date? {
        var newComponents = dateComponents
        let currentYear = Calendar.current.component(.year, from: Date())
        
        newComponents.year = currentYear
        if let thisYearBirthday = Calendar.current.date(from: newComponents), thisYearBirthday > Date() {
            return thisYearBirthday
        } else {
            newComponents.year = currentYear + 1
            return Calendar.current.date(from: newComponents)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(Array(entry.upcomingBirthdays.prefix(3).enumerated()), id: \.element.identifier) { index, contact in
                HStack(spacing: 15) {
                    Text(contact.givenName).font(.caption)
                    Spacer()
                    if let birthday = contact.birthday, let birthdayThisYear = nextBirthday(from: birthday) {
                        if !Calendar.current.isDateInToday(birthdayThisYear) {
                            HStack {
                                Image(systemName: "gift.fill")
                            }
                        } else {
                            Text(birthdayThisYear.relativeString).font(.caption2)
                        }
                    }
                }
                if index < entry.upcomingBirthdays.prefix(3).count - 1 {
                    Divider()
                }
            }
            if entry.upcomingBirthdays.isEmpty {
                Text("No upcoming birthdays.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }.padding()
    }
}

struct ListUpcomingBirthdaysWidget: Widget {
    let kind: String = "BirthdayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BirthdayWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Upcoming Birthdays")
        .description("Shows the upcoming birthdays.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
