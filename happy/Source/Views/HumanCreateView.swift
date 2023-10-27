import SwiftUI

struct HumanCreateView: View {
    @ObservedObject var viewModel = HumanCreateViewModel()
    
    var body: some View {
        VStack(spacing: 15) { // Maintain spacing for visual separation
            TextField("Search", text: $viewModel.searchText)
                .padding(15) // Retaining increased padding for aesthetics
                .background(Color.white)
                .cornerRadius(10) // Retaining the increased corner radius
                .shadow(color: Color.black.opacity(0.1), radius: 1) // Subtle shadow refinement
                .padding(.horizontal, 20)

            List {
                ForEach(viewModel.filteredContacts(), id: \.identifier) { contact in
                    ContactRow(contact: contact, viewModel: viewModel)
                }
            }
            .listStyle(PlainListStyle()) // Keep default separators removed
        }
        .padding(.top)
    }
}
