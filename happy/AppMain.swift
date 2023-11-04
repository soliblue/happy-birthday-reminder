import SwiftUI

@main
struct AppMain: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, CoreDataStack.shared.context)
        }
    }
}
