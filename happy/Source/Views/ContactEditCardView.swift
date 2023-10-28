import SwiftUI
import Contacts

struct ContactEditCardView: View {
    let contact: CNContact
    @State private var showAlert = false
    @State private var selectedDate: Date
    @State private var isDatePickerShown: Bool = false
    @State private var isDatePickerModalShown: Bool = false
    
    var viewModel: ContactViewModel
    
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
                
                // Show date picker for updating the birthdate if necessary
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .onChange(of: selectedDate) {
                        viewModel.updateBirthday(for: contact, with: $0)
                    }
                
                // Show button to clear birthdate
                Button(action: {
                    showAlert = true
                }){
                    Image(systemName: "minus.circle")
                        .foregroundColor(Color("danger"))
                        .clipShape(Circle())
                }.buttonStyle(.bordered)
                .foregroundColor(Color.primary)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Clear Birthday"),
                        message: Text("Are you sure you want to clear the birthdate of \(contact.name)? This action is irreversible."),
                        primaryButton: .destructive(Text("clear")) {
                            viewModel.clearBirthday(for: contact)
                            selectedDate = Date()
                            isDatePickerShown = false
                        },
                        secondaryButton: .cancel(Text("cancel"))
                    )
                }
            } else {
                Button(action: {
                    isDatePickerModalShown = true
                }){
                    Text("add birthdate").font(.callout)
                }.buttonStyle(.bordered).foregroundColor(Color.primary)
                    .sheet(isPresented: $isDatePickerModalShown) {
                        DatePickerModal(isShown: $isDatePickerModalShown, selectedDate: $selectedDate) {
                            let calendar = Calendar.current
                            let today = calendar.startOfDay(for: Date())
                            let selectedDay = calendar.startOfDay(for: selectedDate)
                            if today != selectedDay {
                                isDatePickerShown = true
                                viewModel.updateBirthday(for: contact, with: selectedDate)
                            }
                        }
                    }
            }
        }
        .padding(.vertical)
    }
}
