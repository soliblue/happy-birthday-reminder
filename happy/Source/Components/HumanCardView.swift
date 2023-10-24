import SwiftUI

struct HumanCardView: View {
    var human: Human
    
    var body: some View {
        HStack {
            AvatarView(imageData: human.imageData, size: 50)
            VStack(alignment: .leading) {
                Text(human.nickname ?? human.name)
                    .foregroundColor(human.birthdayPassed ? .gray : .primary)
                Text(human.nextBirthday.relativeString)
                    .foregroundColor(human.birthdayPassed ? .gray : .primary)
            }
            Spacer()
            Text("\(Calendar.current.component(.day, from: human.birthdate))")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(human.birthdayPassed ? .gray : .primary)
        }
    }
}
