import SwiftUI


struct Test: View {
    var body: some View {
        Image("logo").resizable().scaledToFit().background(.white).clipShape(Circle())
    }
}

#Preview {
    Test().preferredColorScheme(.dark).frame(width: 200)
}
