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
                title: Text("wish \(contact.name) a happy birthday"),
                buttons: [
                    .default(Text("send text")) {
                        self.isShowingMessageComposer = true
                    },
                    .default(Text("make a call")) {
                        if let url = URL(string: "tel://\(contact.phoneNumbers.first?.value.stringValue ?? "")"), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    },
                    .destructive(Text("cancel"))
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
