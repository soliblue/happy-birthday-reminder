import SwiftUI

@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
        }
    }
}
