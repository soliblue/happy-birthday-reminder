import SwiftUI
import Contacts

struct ContactCompactCard: View {
    let contact: CNContact
    var viewModel: ContactViewModel
    
    @State private var selectedDate: Date
    @State private var isDatePickerShown: Bool = false
    
    init(contact: CNContact, viewModel: ContactViewModel) {
        self.contact = contact
        self.viewModel = viewModel
        if let birthdate = contact.birthday?.date {
            _selectedDate = State(initialValue: birthdate)
            _isDatePickerShown = State(initialValue: true)
        } else {
            _selectedDate = State(initialValue: Date())
            _isDatePickerShown = State(initialValue: false)
        }
    }
    
    var body: some View {
        HStack {
            Text(contact.name)
                .font(.headline)
                .lineLimit(2)
                .truncationMode(.tail)
            Spacer()
            if isDatePickerShown {
                EditBirthdateButton(
                    contact: contact,
                    viewModel: viewModel,
                    selectedDate: $selectedDate,
                    isDatePickerShown: $isDatePickerShown
                )
                
                ClearBirthdateButton(
                    contact: contact,
                    viewModel: viewModel,
                    isDatePickerShown: $isDatePickerShown
                )
            } else {
                AddBirthdateButton(
                    contact: contact,
                    viewModel: viewModel,
                    selectedDate: $selectedDate,
                    isDatePickerShown: $isDatePickerShown
                )
            }
        }.padding(.vertical)
    }
}

#Preview {
    let mockContactWithBirthday = CNMutableContact()
    mockContactWithBirthday.givenName = "Jane"
    mockContactWithBirthday.familyName = "Smith"
    let calendar = Calendar.current
    let birthdate = calendar.date(byAdding: .year, value: -30, to: Date())!
    mockContactWithBirthday.birthday = calendar.dateComponents([.year, .month, .day], from: birthdate)

    let mockContactWithoutBirthday = CNMutableContact()
    mockContactWithoutBirthday.givenName = "John"
    mockContactWithoutBirthday.familyName = "Doe"

    return VStack(spacing: 20) {
        ContactCompactCard(
            contact: mockContactWithBirthday,
            viewModel: ContactViewModel()
        )
        ContactCompactCard(
            contact: mockContactWithoutBirthday,
            viewModel: ContactViewModel()
        )
    }.padding()
}
