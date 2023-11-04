import SwiftUI
import MessageUI

struct SendMessageButton<Content: View>: View {
    let phoneNumber: String
    let content: Content
    @State private var isShowingMessageComposer = false
    
    init(phoneNumber: String, @ViewBuilder content: () -> Content) {
        self.phoneNumber = phoneNumber
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            self.isShowingMessageComposer = true
        }) {
            content
        }
        .sheet(isPresented: $isShowingMessageComposer) {
            if MFMessageComposeViewController.canSendText() {
                MessageComposeView(recipients: [phoneNumber]) { messageSent in
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

struct MessageComposeView: UIViewControllerRepresentable {
    var recipients: [String]
    var completion: (Bool) -> Void
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = context.coordinator
        messageComposeVC.recipients = recipients
        return messageComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }
    
    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var completion: (Bool) -> Void
        
        init(completion: @escaping (Bool) -> Void) {
            self.completion = completion
        }
        
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true) {
                self.completion(result == .sent)
            }
        }
    }
}
