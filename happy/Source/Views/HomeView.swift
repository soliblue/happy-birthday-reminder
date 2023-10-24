import SwiftUI

struct HomeView: View {
    @State private var isShowingCreateView = false
    
    var body: some View {
        NavigationView {
            VStack {
                HumanListView()
                Button(action: {
                    isShowingCreateView = true 
                }) {
                    Text("Add Birthday")
                }
            }
            .sheet(isPresented: $isShowingCreateView) {
                HumanCreateView() 
            }
        }
    }
}
