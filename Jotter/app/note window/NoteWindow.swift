//
//  Note Window.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 27/01/2024.
//

import SwiftUI
import CoreData

struct NoteWindow: Scene {

    var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    var body: some Scene {
        WindowGroup (id: WindowIdentifiers.noteScene, for: UUID.self) { $uuid in
            NoteSingleView(uuid: uuid)
                .environment(\.managedObjectContext, context)
        }
        .pidDefaultSize(width: 400, height: 600)
        //        .windowStyle(.hiddenTitleBar)
        .pidWindowToolbarStyle()
        .piDefaultPosition(.trailing)
    }
}

#Preview {
    NoteWindow()
        .environment(\.managedObjectContext,
                      PersistenceController.shared.container.viewContext) as! any View
}
