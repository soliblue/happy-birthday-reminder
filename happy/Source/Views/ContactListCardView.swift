import SwiftUI
import Contacts

struct ContactListCardView: View {
    let contact: CNContact
    @State private var showAlert = false
    @State private var selectedDate: Date
    @State private var showShareSheet: Bool = false
    @State private var showDatePickerSheet: Bool = false
    
    var viewModel: ContactViewModel
    
    
    init(contact: CNContact, viewModel: ContactViewModel) {
        self.contact = contact
        self.viewModel = viewModel
        if let birthdate = contact.birthday?.date {
            _selectedDate = State(initialValue: birthdate)
        } else {
            _selectedDate = State(initialValue: Date())
        }
    }
    
    var body: some View {
        HStack{
            if let birthday = contact.birthday, let birthDate = Calendar.current.date(from: birthday) {
                Text(String(format: "%02d", Calendar.current.component(.day, from: birthDate)))
                    .font(.title2)
                    .padding(.trailing, 10)
                
            }
            
            
            
            Avatar(imageData: contact.thumbnailImageData, size: 45)
//                .blur(radius: 5)
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                    .lineLimit(1)
//                    .blur(radius: ["Jeffry","Whitney","Ahmed",].contains(contact.givenName) ? 0 : 5)
                if let age = contact.age {
                    Text("\(age) years old").font(.subheadline)
                }
            }
            Spacer()
            VStack {
                if contact.hasBirthday() {
                    Button(action: {
                        showShareSheet.toggle()
                    }) {
                        BirthdayIcon()
                    }
                    .sheet(isPresented: $showShareSheet) {
                        ShareSheet(items: ["happy birthday 🎉"])
                    }
                } else {
                    if let nextBirthdayString = contact.nextBirthday?.relativeString {
                        Text(nextBirthdayString).font(.caption)
                    }
                    if let birthday = contact.birthday, let birthDate = Calendar.current.date(from: birthday) {
                        Text(String(format: "%04d", Calendar.current.component(.year, from: birthDate))).font(.caption2)
                    }
                }
                
            }
        }
        .onTapGesture(count: 2) {
            viewModel.toggleIsFavorite(for: contact)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .padding(7.5)
        .swipeActions(edge: .trailing){
            Button(action: {
                showDatePickerSheet = true
            }){
                Text("edit")
            }.colorInvert()
        }.swipeActions(edge: .leading){
            Button(action: {
                showAlert = true
            }){
                Text("clear")
                
            }
            .tint(Color("danger"))
            
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
            
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text("Clear Birthday"),
                message: Text("Are you sure you want to clear the birthdate of \(contact.name)? This action is irreversible."),
                primaryButton: .destructive(Text("clear")) {
                    viewModel.clearBirthday(for: contact)
                    selectedDate = Date()
                },
                secondaryButton: .cancel(Text("cancel"))
            )
        }
        
    }
}
