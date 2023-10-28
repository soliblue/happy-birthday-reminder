import SwiftUI

struct BirthdayIcon: View {
    var size: CGFloat = 24
    
    var body: some View {
        Image(systemName: "gift.fill")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(.blue)
    }
}
