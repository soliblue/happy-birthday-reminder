import SwiftUI

struct ListContacts: View {
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.accessDenied {
                AllowContactsAccess()
            } else if !viewModel.contacts.isEmpty && viewModel.monthSections.isEmpty {
                ListContactsIsEmpty()
            } else {
                
                ScrollViewReader { proxy in
                    List{
                        ForEach(viewModel.monthSectionsSortedKeys, id: \.self) { monthInfo in
                            Section(header: HStack {
                                Text(monthInfo.name).font(.title3).id(monthInfo.name)
                                Spacer()
                                    Text("\(viewModel.monthSections[monthInfo]?.count ?? 0)")
                            }) {
                                ForEach(viewModel.monthSections[monthInfo] ?? [], id: \.self) { contact in
                                    ContactCard(contact: contact, viewModel: viewModel)
                                }
                            }
                            .id(monthInfo.name)
                        }
                    }
                    .padding(.top,1)
                    .listStyle(PlainListStyle())
                    .refreshable {
                        viewModel.fetchContacts()
                    }.showWidgetAlertSheet()
                }
            }
        }
    }
}

#Preview {
    ListContacts()
}
