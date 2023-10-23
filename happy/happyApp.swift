//
//  happyApp.swift
//  happy
//
//  Created by Soli on 23.10.23.
//

import SwiftUI

@main
struct happyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
