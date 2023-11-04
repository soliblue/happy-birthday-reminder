import SwiftUI

struct AllowContactsAccess: View {
    var body: some View {
        VStack(spacing:25) {
            VStack(spacing: 5){
                Image(systemName: "person.crop.circle.badge.xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("No Contacts Found").font(.headline)
                Text("Please allow access to your contacts").font(.subheadline)
            }
            VStack(spacing:5){
                Button("Enable Access") {
                    if let url = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                Text("Your data remains on this device.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
