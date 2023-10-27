import SwiftUI

struct HomeView: View {
    @State private var isShowingCreateView = false
    var body: some View {
        NavigationView {
            ZStack {
                HumanListView()
                VStack {
                    Spacer()
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
                NavigationView {
                    VStack {
                        HumanCreateView()
                    }
                    .navigationBarItems(trailing: Button("Close") {
                        isShowingCreateView = false
                    })
                    .navigationBarTitle("", displayMode: .inline)
                }
            }
        }
    }
}
