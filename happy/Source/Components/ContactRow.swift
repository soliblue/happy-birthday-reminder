import SwiftUI
import Contacts

struct ContactRow: View {
    let contact: CNContact
    @State private var selectedDate: Date
    @State private var isDatePickerShown: Bool = false
    @State private var isDatePickerModalShown: Bool = false
    
    var viewModel: HumanCreateViewModel
    
    init(contact: CNContact, viewModel: HumanCreateViewModel) {
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
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
//                .blur(radius: 5)
            Spacer()
            if isDatePickerShown {
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden()
                    .onChange(of: selectedDate) {
                        viewModel.updateBirthday(for: contact, with: $0)
                    }
            } else {
                Button(action: {
                    isDatePickerModalShown = true
                }){
                    Text("add birthdate").font(.callout)
                }.buttonStyle(.bordered).foregroundColor(Color.primary)
                .sheet(isPresented: $isDatePickerModalShown) {
                    NavigationView {
                        VStack {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                        }
                        .navigationBarItems(trailing: Button("close") {
                            isDatePickerModalShown = false
                        })
                        .onDisappear {
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
        }
        .padding(.vertical)
    }
}
