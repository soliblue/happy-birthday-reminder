import SwiftUI
import Contacts

struct AddBirthdateButton: View {
    var contact: CNContact
    var viewModel: ContactViewModel
    @Binding var selectedDate: Date
    @Binding var isDatePickerShown: Bool

    @State private var isDatePickerModalShown: Bool = false

    var body: some View {
        Button(action: {
            isDatePickerModalShown = true
        }) {
            Text("Add Birthdate").font(.callout)
        }
        .buttonStyle(.bordered)
        .foregroundColor(Color.primary)
        .sheet(isPresented: $isDatePickerModalShown) {
            NavigationView {
                VStack {
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                }
                .navigationBarItems(trailing: Button("Close") {
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let selectedDay = calendar.startOfDay(for: selectedDate)
                    // Check if the selected date is not today's date
                    if today != selectedDay {
                        viewModel.updateBirthday(for: contact, with: selectedDate)
                        isDatePickerShown = true
                    } else {
                        isDatePickerShown = false
                    }
                    isDatePickerModalShown = false
                })
            }
        }
    }
}

#Preview {
    let mockContact = CNMutableContact()
    mockContact.givenName = "John"
    mockContact.familyName = "Doe"
    
    return AddBirthdateButton(
        contact: mockContact,
        viewModel: ContactViewModel(),
        selectedDate: .constant(Date()),
        isDatePickerShown: .constant(true)
    )
}
