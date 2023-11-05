import SwiftUI
import Contacts
import WidgetKit

struct BirthdayEntry: TimelineEntry {
    let date: Date
    let upcomingBirthdays: [CNContact]
}

struct BirthdayWidgetEntryView: View {
    var entry: BirthdayEntry
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(Array(entry.upcomingBirthdays.enumerated()), id: \.element.identifier) { index, contact in
                WidgetContactCard(contact: contact)
                if index < entry.upcomingBirthdays.count - 1 {
                    Divider()
                }
            }
            if entry.upcomingBirthdays.isEmpty {
                Text("No upcoming birthdays.")
                    .font(.subheadline)
            }
        }.padding()
    }
}
