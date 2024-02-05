//
//  NewItemCommand.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 29/01/2024.
//

import SwiftUI

struct NewItemCommand: Commands {
    @Environment(\.managedObjectContext) var context
    @FocusedObject private var stateManager: NavigationStateManager?
    var body: some Commands {
        CommandGroup(before: .newItem) {
            Button("Add new Note") {
                stateManager?.addNote()
            }
            .disabled(stateManager?.selectedFolder == nil)
            .keyboardShortcut("N", modifiers: [.command, .control])
            
            Button("Add new Folder") {
                stateManager?.addFolder()
            }
            .disabled(stateManager == nil)
            .keyboardShortcut("F", modifiers: [.command, .control])

        }
    }
}

