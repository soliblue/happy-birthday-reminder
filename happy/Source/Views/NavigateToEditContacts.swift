import SwiftUI

struct NavigateToEditContacts: View {
    @State private var isShowingCreateView = false
    
    var body: some View {
        Button(action: {
            isShowingCreateView = true
        }) {
            Image(systemName: "plus")
                .font(.largeTitle)
                .padding()
                .background(Color.primary.colorInvert())
                .cornerRadius(40)
        }
        .accessibilityLabel(Text("Create new contact"))
        .padding(.trailing)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .sheet(isPresented: $isShowingCreateView) {
            NavigationView {
                VStack {
                    EditContacts()
                }
                .navigationBarItems(trailing: Button("Close") {
                    isShowingCreateView = false
                })
            }
        }
    }
}

#Preview {
    NavigateToEditContacts()
}
