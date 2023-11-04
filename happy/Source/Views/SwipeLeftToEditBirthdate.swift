import SwiftUI
import Contacts

struct SwipeLeftToEditBirthdate: ViewModifier {
    var contact: CNContact
    var viewModel: ContactViewModel

    @State private var selectedDate: Date
    @State private var showDatePickerSheet: Bool = false
    
    init(contact: CNContact, viewModel: ContactViewModel) {
        self.contact = contact
        self.viewModel = viewModel
        if let birthdate = contact.birthday?.date {
            _selectedDate = State(initialValue: birthdate)
        } else {
            _selectedDate = State(initialValue: Date())
        }
    }

    func body(content: Content) -> some View {
        content
            .swipeActions(edge: .trailing) {
                Button {
                    showDatePickerSheet = true
                } label: {
                    Text("Edit")
                }.colorInvert()
            }
            .sheet(isPresented: $showDatePickerSheet){
                NavigationView {
                    VStack {
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .onChange(of: selectedDate) {
                                viewModel.updateBirthday(for: contact, with: $0)
                            }
                        
                    }
                    .navigationBarItems(trailing: Button("close") {
                        showDatePickerSheet = false
                    })
                }
            }
    }
}

extension View {
    func swipeLeftToEditBirthdate(contact: CNContact, viewModel: ContactViewModel) -> some View {
        self.modifier(SwipeLeftToEditBirthdate(contact: contact, viewModel: viewModel))
    }
}
