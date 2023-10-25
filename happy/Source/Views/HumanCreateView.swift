import SwiftUI

struct HumanCreateView: View {
    @ObservedObject var viewModel = HumanCreateViewModel()
    
    var body: some View {
        VStack {
            TextField("Search", text: $viewModel.searchText)
                .padding()
            List {
                ForEach(viewModel.filteredContacts(), id: \.identifier) { contact in
                    ContactRow(contact: contact, viewModel: viewModel)
                }
            }
        }
        .padding(.top)
        .navigationBarTitle("Add Birthday", displayMode: .inline)
    }
}
