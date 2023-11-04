import SwiftUI
import WidgetKit

@main
struct WidgetMain: WidgetBundle {
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

    var body: some Widget {
        ListUpcomingBirthdaysWidget()
    }
}
