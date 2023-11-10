import SwiftUI
import Contacts

struct SwipeRightToClearBirthdate: ViewModifier {
    var contact: CNContact
    var viewModel: ContactViewModel

    @State private var showAlert = false
    
    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .leading) {
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .tint(.red)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Clear Birthday"),
                    message: Text("Are you sure you want to clear the birthdate of \(contact.name)? This action is irreversible."),
                    primaryButton: .destructive(Text("Clear")) {
                        viewModel.updateBirthday(for: contact)
                    },
                    secondaryButton: .cancel()
                )
            }
    }
}

extension View {
    func swipeRightToClearBirthdate(contact: CNContact, viewModel:ContactViewModel) -> some View {
        self.modifier(SwipeRightToClearBirthdate(contact: contact, viewModel: viewModel))
    }
}
