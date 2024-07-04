import SwiftUI
import Contacts
import WidgetKit

struct WidgetContactCard: View {
    let contact: CNContact
    
    var body: some View {
        if let relevantBirthday = contact.relevantBirthday {
            HStack{
                Avatar(imageData: contact.thumbnailImageData, size: 20).scaledToFit()
                Text(contact.shortName)
                    .lineLimit(1)
                    .font(.caption)
                Spacer()
                if relevantBirthday.isToday {
                    BirthdayIcon(size: 15)
                } else {
                    Text(relevantBirthday.relativeString).font(.caption2).scaleEffect(0.75).lineLimit(1)
                }
            }
        }
        
    }
}
