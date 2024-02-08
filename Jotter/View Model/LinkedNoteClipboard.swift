//
//  LinkedNoteClipboard.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 04/02/2024.
//

import Foundation

class LinkedNoteClipboard: ObservableObject {
    
    @Published var noteIds: [UUID] = []
    
    func addNote(_ note: Note) {
        guard !noteIds.contains(where: {$0 == note.uuid }) else {return}
        noteIds.append(note.uuid)
    }
    
    static func preview() -> LinkedNoteClipboard {
        let clipboard = LinkedNoteClipboard()
        
        let context = PersistenceController.preview.container.viewContext
        
        let note1 = Note(title: "Note 2", context: context)
        let note2 = Note(title: "Note 2", context: context)
        let note3 = Note(title: "Note 3", context: context)

        
        clipboard.noteIds = [note1.uuid, note2.uuid, note3.uuid]
        return clipboard
    }
    
    
}
