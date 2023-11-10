import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            ZStack {
                ListContacts()
                NavigateToEditContacts()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
