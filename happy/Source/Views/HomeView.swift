import SwiftUI

struct HomeView: View {
    @State private var isShowingCreateView = false
    // ... any other state or bindings
    
    var body: some View {
        NavigationView {
            ZStack {
                // Refreshable modifier can be added here once it's supported in SwiftUI
                // For now, you might need a custom solution or a package to support pull-to-refresh.
                HumanListView()
                VStack {
                    Spacer()
                    
                    // Floating action button
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingCreateView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.primary.colorInvert())
                                .cornerRadius(40)
                                .padding(.trailing)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            isShowingCreateView = true
                                        }
                                )
                        }
                    }
                }
                
            }
            .sheet(isPresented: $isShowingCreateView) {
                HumanCreateView()
            }
        }
    }
}
