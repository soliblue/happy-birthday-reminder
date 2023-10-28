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
            HStack{
                // Displaying the day of the birthday
                if let birthday = contact.birthday, let birthDate = Calendar.current.date(from: birthday) {
                    Text(String(format: "%02d", Calendar.current.component(.day, from: birthDate)))
                        .font(.title2)
                        .padding(.trailing, 10)
                }
                // Displaying the avatar
                Avatar(imageData: contact.thumbnailImageData, size: 45)
                // Displaying the name and age
                VStack(alignment: .leading) {
                    Text(contact.name)
                        .font(.headline)
                        .lineLimit(1)
                    if !contact.hasBirthday() {
                        if let nextBirthdayString = contact.nextBirthday?.relativeString {
                            Text(nextBirthdayString).font(.subheadline)
                        }
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
                            ShareSheet(items: ["Happy Birthday 🎉 \(contact.name)"])
                        }
                    } else {
                        if let age = contact.age {
                            Text("\(age) years").font(.caption)
                        }
                        if let date = contact.birthday?.date {
                            Text(date.shortString).font(.caption2).foregroundColor(Color.secondary)
                        }
                        
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .padding(5)
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
}
