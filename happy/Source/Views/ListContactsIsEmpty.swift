import SwiftUI

struct ListContactsIsEmpty: View {
    var body: some View {
        VStack(spacing: 20){
            Image(systemName: "calendar.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(Color.accentColor)
            Text("Add Birthdates")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("No birthdates were found in your contacts. Tap the '+' icon in the bottom right corner to add them.")
                .font(.body)
                .padding(.horizontal)
            
        }.padding()
    }
}
