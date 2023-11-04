import SwiftUI
import Contacts
import MessageUI

struct ContactBirthdayActions: View {
    let contact: CNContact
    let birthdate: Date
    @State private var showingActionSheet = false
    @State private var isShowingMessageComposer = false

    var body: some View {
        HStack {
            Button(action: {
                self.showingActionSheet = true
            }) {
                BirthdayIcon()
            }.buttonStyle(.borderedProminent)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Contact Options"),
                message: Text("Wish \(contact.givenName) a happy birthday!"),
                buttons: [
                    .default(Text("Send Text")) {
                        self.isShowingMessageComposer = true
                    },
                    .default(Text("Make a Call")) {
                        if let url = URL(string: "tel://\(contact.phoneNumbers.first?.value.stringValue ?? "")"), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    },
                    .cancel(Text("Cancel"))
                ]
            )
        }
        .sheet(isPresented: $isShowingMessageComposer) {
            if MFMessageComposeViewController.canSendText() {
                MessageComposeView(recipients: [contact.phoneNumbers.first?.value.stringValue ?? ""]) { messageSent in
                    // Handle the message sent completion
                    print("Message sent: \(messageSent)")
                }
            } else {
                // Handle the error case where messages cannot be sent
                Text("This device is not capable of sending text messages.")
            }
        }
    }
}
