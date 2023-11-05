import SwiftUI

struct AllowContactsAccess: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.badge.xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.accentColor)
            Text("Enable Contact Access")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("Store and manage birthdays directly in your contacts. They'll remain even if the app is uninstalled. Your data stays on device and is never shared with us.")
                .font(.body)
                .padding(.horizontal)
            
            Button("Enable Access") {
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            .font(.headline)
            .padding(.horizontal)
            .multilineTextAlignment(.center)

        }.padding()
    }
}
