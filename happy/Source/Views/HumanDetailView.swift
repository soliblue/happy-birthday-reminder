import SwiftUI

struct HumanDetailView: View {
    @State var now = Date() // This will keep updating
    var human: Human
    
    var body: some View {
        let timeTillBirthday = now.difference(to: human.nextBirthday)
        
        return ScrollView {
            VStack(alignment: .center, spacing: 20) {
                AvatarView(imageData: human.imageData, size: 100)
                Text("\(human.age) years old")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Spacer()
                TimeView(title: "Time till Birthday", days: timeTillBirthday.days, hours: timeTillBirthday.hours, minutes: timeTillBirthday.minutes, seconds: timeTillBirthday.seconds)
                
            }
            .padding()
            .onAppear {
                // Start a timer that fires every second
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    now = Date()
                }
            }
        }
        .navigationBarTitle(human.nickname ?? human.name, displayMode: .inline)
    }
}
