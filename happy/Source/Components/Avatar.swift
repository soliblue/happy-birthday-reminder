import SwiftUI

struct Avatar: View {
    var imageData: Data?
    var size: CGFloat
    
    var body: some View {
        Group {
            if let imageData = imageData {
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            }
          
        }
    }
}
