import SwiftUI
import Contacts

struct ContactRow: View {
    let contact: CNContact
    @State private var selectedDate: Date
    var viewModel: HumanCreateViewModel
    
    init(contact: CNContact, viewModel: HumanCreateViewModel) {
        self.contact = contact
        self.viewModel = viewModel
        if let birthdate = contact.birthday?.date {
            _selectedDate = State(initialValue: birthdate)
        } else {
            _selectedDate = State(initialValue: Date())
        }
    }
    
    var body: some View {
        HStack {
            AvatarView(imageData: contact.imageData, size: 25)
            Text(contact.givenName + " " + contact.familyName)
            Spacer()
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .onChange(of: selectedDate) {
                    viewModel.updateBirthday(for: contact, with: $0)
                }
        }
    }
}
