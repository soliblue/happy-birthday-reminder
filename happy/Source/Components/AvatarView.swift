import SwiftUI

struct AvatarView: View {
    var imageData: Data?
    var size: CGFloat
    
    var body: some View {
        Group {
            if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 1)
            } else {
                Image(systemName: "person.crop.square.fill")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(.gray)
            }
        }
    }
}
