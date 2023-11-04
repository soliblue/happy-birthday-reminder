import SwiftUI
import Contacts

struct ContactListCompactCardView: View {
    let contact: CNContact

    var body: some View {
        HStack{
            Avatar(imageData: contact.thumbnailImageData, size: 15)
            Text(contact.shortName)
                .lineLimit(1)
                .font(.caption)
                
            Spacer()
            VStack {
                if contact.hasBirthday() {
                    BirthdayIcon(size: 15)
                } else {
                    if let nextBirthdayString = contact.nextBirthday?.relativeString {
                        Text(nextBirthdayString).font(.caption)
                    }
                }
            }
        }
    }
}
