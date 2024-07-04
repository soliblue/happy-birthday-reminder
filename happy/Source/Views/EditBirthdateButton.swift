import SwiftUI
import Contacts

struct EditBirthdateButton: View {
    var contact: CNContact
    var viewModel: ContactViewModel
    @Binding var selectedDate: Date
    @Binding var isDatePickerShown: Bool

    var body: some View {
        DatePicker("", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(CompactDatePickerStyle())
            .labelsHidden()
            .onChange(of: selectedDate) { newDate in
                viewModel.updateBirthday(for: contact, with: newDate)
            }
    }
}

#Preview {
    let mockContact = CNMutableContact()
    mockContact.givenName = "John"
    mockContact.familyName = "Doe"
    
    return EditBirthdateButton(
        contact: mockContact,
        viewModel: ContactViewModel(),
        selectedDate: .constant(Date()),
        isDatePickerShown: .constant(true)
    )
}
