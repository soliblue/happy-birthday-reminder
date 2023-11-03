import ContactsUI
import SwiftUI

struct ContactEditEmptyView: View {
    var viewModel: ContactViewModel
    @State private var isShowingContactView = false
    
    var body: some View {
        VStack(spacing: 25) {
            Image(systemName: "person.crop.circle.badge.xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            Text("No Matches Found")
                .font(.headline)
            Button("Create new Contact") {
                isShowingContactView = true
            }
            .padding(.top, 10)
        }
        .sheet(isPresented: $isShowingContactView) {
            CNContactViewControllerWrapper()
        }
        .onChange(of: isShowingContactView){ newValue in
            if (!newValue) {
                viewModel.fetchContacts()
            }
        }
    }
}

struct CNContactViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        let contact = CNMutableContact()
        let contactVC = CNContactViewController(forNewContact: contact)
        contactVC.delegate = context.coordinator
        let nav = UINavigationController(rootViewController: contactVC)
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update the UI if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CNContactViewControllerDelegate {
        var parent: CNContactViewControllerWrapper
        
        init(_ parent: CNContactViewControllerWrapper) {
            self.parent = parent
        }
        
        // Implement the delegate methods if needed
    }
}
