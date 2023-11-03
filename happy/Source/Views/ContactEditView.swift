import SwiftUI

struct ContactEditView: View {
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            SearchBar(text: $viewModel.searchText)
            if viewModel.filteredContacts().isEmpty {
                // This will show when the filtered contacts are empty
                ContactEditEmptyView(viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(viewModel.filteredContacts(), id: \.identifier) { contact in
                        ContactEditCardView(contact: contact, viewModel: viewModel)
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
