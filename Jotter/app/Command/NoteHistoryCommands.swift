//
//  NoteHistoryCommands.swift
//  Jotter
//
//  Created by macbook on 01/12/2023.
//

import SwiftUI

struct NoteHistoryCommands: Commands {
    @FocusedObject private var stateManager: NavigationStateManager?
    
    var body: some Commands {
        
        if let notes = stateManager?.noteHistory.reversed() {
            CommandGroup(after: .newItem) {
                Menu("Open Recent") {
                    ForEach(notes) {note in
                        Button {
                            stateManager?.noteChanged(to: note)
                        }label: {
                            Label(note.title, systemImage: "note.text")
                                .labelStyle(.titleAndIcon)
                        }.disabled(stateManager?.selectedNote == note)
                    }
                    Button {
                        stateManager?.noteHistory = []
                    } label: {
                        Text("Clear all")
                    }
                }
            }
        }
    }
}
