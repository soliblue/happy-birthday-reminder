import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}


struct HumanCardView: View {
    var human: Human
    @State private var showShareSheet = false
    
    var body: some View {
        HStack {
            // Adding the Day Element
            // Adding the Day Element
            if !human.hasBirthday() {
                Text(String(format: "%02d", Calendar.current.component(.day, from: human.birthdate)))
                    .font(.title2)
                    .foregroundColor(.primary)
                    .padding(.trailing, 10)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [.primary, .primary]), startPoint: .top, endPoint: .bottom)
                    )
                    .mask(Text(String(format: "%02d", Calendar.current.component(.day, from: human.birthdate))).font(.title))
            } else {
                Text(String(format: "%02d", Calendar.current.component(.day, from: human.birthdate)))
                    .font(.title2)
                    .padding(.trailing, 10)
                    .overlay(
                        LinearGradient(gradient: Gradient(colors: [.primary, .secondary]), startPoint: .top, endPoint: .bottom)
                    )
                    .mask(Text(String(format: "%02d", Calendar.current.component(.day, from: human.birthdate))).font(.title))
            }
            

            
            AvatarView(imageData: human.imageData, size: 45)
            VStack(alignment: .leading) {
                Text(human.nickname ?? human.name).font(.headline)
                if let validAge = human.age {
                    Text("\(validAge) years old").font(.subheadline)
                }

            }
            
            Spacer()
            VStack {
                if human.hasBirthday() {
                    Button(action: {
                        showShareSheet.toggle()
                    }) {
                        BirthdayIcon()
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(items: ["Happy Birthday 🎉 \(human.nickname ?? human.name)"])
                    }
                } else {
                    Text(human.nextBirthday.relativeString).font(.caption)
                }
            }
        }
    }
}
