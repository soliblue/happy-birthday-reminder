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
    
    var displayName: String {
        if !contact.nickname.isEmpty {
            return contact.nickname
        } else {
            return contact.givenName + " " + contact.familyName
        }
    }
    
    var body: some View {
        HStack {
            Text(displayName)
                .lineLimit(1)
                .truncationMode(.tail)
            Spacer()
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
                .onChange(of: selectedDate) {
                    viewModel.updateBirthday(for: contact, with: $0)
                }
        }.padding(.vertical)
    }
}
