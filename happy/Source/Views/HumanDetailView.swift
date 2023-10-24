import SwiftUI

struct HumanDetailView: View {
    var human: Human
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                AvatarView(imageData: human.imageData, size: 100)
                Text(human.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text(human.nextBirthday.longString)
                    .font(.title)
                if let nickname = human.nickname {
                    Text("Nickname: \(nickname)")
                        .font(.subheadline)
                }
                if let phoneNumber = human.phoneNumber {
                    Text("Phone: \(phoneNumber)")
                        .font(.subheadline)
                }
                if let email = human.email {
                    Text("Email: \(email)")
                        .font(.subheadline)
                }
            }
            .padding()
        }
        .navigationBarTitle(human.name, displayMode: .inline)
    }
}
