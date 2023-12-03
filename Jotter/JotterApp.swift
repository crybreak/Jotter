//
//  JotterApp.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI

@main
struct JotterApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #if os(iOS)
        .onChange(of: scenePhase) {newScenePhase in
            if  newScenePhase == .background {
                print("➡️ main app - background")
                persistenceController.save()
            }
        }
        #endif
        .commands {
            CommandGroup (replacing: .saveItem) {
                Button("Save") {
                    persistenceController.save()
                }.keyboardShortcut("S", modifiers: [.command])
            }
            NoteHistoryCommands()
        }
    }
}
