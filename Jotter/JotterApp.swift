//
//  JotterApp.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI

@main
struct JotterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
