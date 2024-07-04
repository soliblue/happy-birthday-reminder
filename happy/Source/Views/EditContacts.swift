import SwiftUI

struct EditContacts: View {
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            SearchBar(text: $viewModel.searchText)
            if viewModel.filteredContacts().isEmpty {
                CreateContact(viewModel: viewModel)
            } else {
                List {
                    ForEach(viewModel.filteredContacts(), id: \.identifier) { contact in
                        ContactCompactCard(contact: contact, viewModel: viewModel)
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    EditContacts()
}
