import SwiftUI
import Contacts
import WidgetKit

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

struct BirthdayEntry: TimelineEntry {
    let date: Date
    let upcomingBirthdays: [CNContact]
}

struct BirthdayWidgetEntryView: View {
    var entry: BirthdayEntry
    
    var body: some View {
        VStack{
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
            }.widgetBackground(Color(UIColor.systemBackground))
        }.padding(.all, 10)
      
        
    }
}
