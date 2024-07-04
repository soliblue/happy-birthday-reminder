import SwiftUI
import Contacts

struct ClearBirthdateButton: View {
    var contact: CNContact
    var viewModel: ContactViewModel
    
    @State private var showAlert = false
    @Binding var isDatePickerShown: Bool
    
    var body: some View {
        Button(action: {
            showAlert = true
        }) {
            Image(systemName: "minus.circle")
                .foregroundColor(Color.red)
                .clipShape(Circle())
        }
        .buttonStyle(.bordered)
        .foregroundColor(Color.primary)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Clear Birthday"),
                message: Text("Are you sure you want to clear the birthdate of \(contact.name)? This action is irreversible."),
                primaryButton: .destructive(Text("Clear")) {
                    viewModel.updateBirthday(for: contact)
                    isDatePickerShown = false
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    let mockContact = CNMutableContact()
    mockContact.givenName = "John"
    mockContact.familyName = "Doe"
    
    return ClearBirthdateButton(
        contact: mockContact,
        viewModel: ContactViewModel(),
        isDatePickerShown: .constant(true)
    )
}
