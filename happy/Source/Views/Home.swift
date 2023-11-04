import SwiftUI

struct Home: View {
    @State private var isShowingCreateView = false
    var body: some View {
        NavigationView {
            ZStack {
                ListContacts()
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
                        EditContacts()
                    }
                    .navigationBarItems(trailing: Button("close") {
                        isShowingCreateView = false
                    })
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
