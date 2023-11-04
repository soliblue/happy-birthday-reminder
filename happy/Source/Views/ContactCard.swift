import SwiftUI
import Contacts

struct ContactCard: View {
    let contact: CNContact
    var viewModel: ContactViewModel
    
    var body: some View {
        if let birthdate = contact.birthday?.date {
            HStack {
                Text(birthdate.dayWithLeadingZero)
                    .font(.title2)
                Avatar(imageData: contact.thumbnailImageData, size: 45)
                VStack(alignment: .leading){
                    Text(contact.name)
                        .font(.headline)
                    Text("\(birthdate.yearsSince) years old")
                        .font(.subheadline)
                }
                Spacer()
                if birthdate.relevantBirthday.isToday {
                    ContactBirthdayActions(contact: contact, birthdate: birthdate)
                } else {
                    Text(birthdate.relevantBirthday.relativeString)
                        .font(.caption2)
                }
            }
            .padding(5)
            .swipeRightToClearBirthdate(contact: contact, viewModel: viewModel)
            .swipeLeftToEditBirthdate(contact: contact, viewModel: viewModel)
        }
    }
}
