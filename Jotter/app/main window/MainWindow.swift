//
//  Main Window.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 27/01/2024.
//

import SwiftUI
import CoreData

struct MainWindow: Scene {
    let persistenceController = PersistenceController.shared

    var context: NSManagedObjectContext { persistenceController.container.viewContext}
    
    @AppStorage(wrappedValue: false, AppStorageKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool
    
    @StateObject var clipboard = LinkedNoteClipboard()

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(clipboard)
            } else {
                OnboardingView()
            }
        }
        #if os(OSX)
        .defaultSize(width: 1200, height: 600)
        .commands {
          
            CommandGroup (replacing: .saveItem) {
                Button("Save") {
                    persistenceController.save()
                }.keyboardShortcut("S", modifiers: [.command])
            }
            NoteHistoryCommands()
            HelpCommands()
            NewItemCommand()
            NoteStatusCommands()
            NavigationCommands()

            
            //Default command system
            SidebarCommands()
            TextFormattingCommands()
            TextEditingCommands()
            ImportFromDevicesCommands()
        }
        #endif
        
    }
}

#Preview {
    MainWindow()
        .environment(\.managedObjectContext,
                      PersistenceController.shared.container.viewContext) as! any View
}
