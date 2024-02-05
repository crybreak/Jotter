//
//  NoteStatusCommands.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 29/01/2024.
//

import SwiftUI

struct NoteStatusCommands: Commands {
    
    @FocusedBinding(\.selectedNote) var selectedNote
    var body: some Commands {
        CommandGroup(before: .undoRedo) {
            if let note = selectedNote {
                
//                NoteStatusPickerView(note: note)
                
                Menu("Note Status for: " + note.title) {
                    ForEach(Status.allCases) { status in
                        Button {
                            note.status = status
                        } label: {
                            if status == note.status {
                                Label(status.rawValue, systemImage: "checkmark")
                            } else {
                                Text(status.rawValue)
                            }
                        }.labelStyle(.titleAndIcon)
                            .keyboardShortcut(key(for: status), modifiers: [.control, .command])

                    }
                }
               
            }
        }
    }
    
    func key(for status: Status) -> KeyEquivalent {
        switch status {
        case .draft:
            return "D"
        case .review:
            return "R"
        case .archieve:
            return "A"

        }
    }
}

struct SelectedNoteKey: FocusedValueKey {
    typealias Value = Binding<Note>
}

extension FocusedValues {
    var selectedNote : Binding<Note>? {
        get {self[SelectedNoteKey.self]}
        set {self[SelectedNoteKey.self] = newValue}
    }
}
