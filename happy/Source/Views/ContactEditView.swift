import SwiftUI

struct ContactEditView: View {
    @ObservedObject var viewModel = ContactViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            SearchBar( text: $viewModel.searchText)
            List {
                ForEach(viewModel.filteredContacts(), id: \.identifier) { contact in
                    ContactEditCardView(contact: contact, viewModel: viewModel)
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .listStyle(PlainListStyle()) 
        }.padding(.horizontal)
    }
}
