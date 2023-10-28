import SwiftUI
import Contacts

struct ContactListCardView: View {
    let contact: CNContact
    @State private var showShareSheet = false
    
    var body: some View {
        HStack {
            // Displaying the day of the birthday
            if let birthday = contact.birthday, let birthDate = Calendar.current.date(from: birthday) {
                Text(String(format: "%02d", Calendar.current.component(.day, from: birthDate)))
                    .font(.title2)
                    .padding(.trailing, 10)
            }
            // Displaying the avatar
            Avatar(imageData: contact.thumbnailImageData, size: 45)
            // Displaying the name and age
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                
                // Calculate age if birthday is available
                if let age = contact.age {
                    Text("\(age) years old").font(.subheadline)
                }
            }
            Spacer()
            VStack {
                if contact.hasBirthday() {
                    Button(action: {
                        showShareSheet.toggle()
                    }) {
                        BirthdayIcon()
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(items: ["Happy Birthday 🎉 \(contact.name)"])
                    }
                } else {
                    if let nextBirthdayString = contact.nextBirthday?.relativeString {
                        Text(nextBirthdayString).font(.caption)
                    }
                }
            }
        }
        .padding()
    }
}
