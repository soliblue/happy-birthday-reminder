import SwiftUI

struct HumanCreateView: View {
    @ObservedObject var viewModel = HumanCreateViewModel()
    
    var body: some View {
        VStack(spacing: 15) {
            SearchBar( text: $viewModel.searchText)
               
            
            List {
                ForEach(viewModel.filteredContacts(), id: \.identifier) { contact in
                    ContactRow(contact: contact, viewModel: viewModel)
                }
            }
            .listStyle(PlainListStyle()) 
        }
    }
}
