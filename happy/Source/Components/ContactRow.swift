import SwiftUI
import Contacts

struct ContactRow: View {
    let contact: CNContact
    @State private var selectedDate: Date = Date()
    var viewModel: HumanCreateViewModel
    
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
