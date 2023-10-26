import SwiftUI

struct BirthdayIcon: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(
            Image(systemName: "gift.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        )
        .frame(width: 24, height: 24)  // Adjust frame to match icon size
        .padding()  // Add padding if necessary
    }
}
