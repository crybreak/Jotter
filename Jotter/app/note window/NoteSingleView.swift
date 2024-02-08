//
//  NoteSingleView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 26/01/2024.
//

import SwiftUI

struct NoteSingleView: View {
    
    init(uuid: UUID?) {
        if let uuid {
            let request = Note.createFetchRequest(uuid)
            self._notes = FetchRequest(fetchRequest: request)
        }
    }
    
    @FetchRequest(fetchRequest: Note.fetch(.none))
    
    private var notes : FetchedResults<Note>
    
    var body: some View {
        Group {
            if let note = notes.first {
                ContentDetailNote(note: note)
                    .navigationTitle(note.title)
            } else {
                Text("Sorry, we could not find your note")
            }
        }
        .environmentObject(NavigationStateManager())
        .frame(minWidth: 300, minHeight: 300)
          
       
    }
}

#Preview {
    
    let note = Note.example()
    return NoteSingleView(uuid: note.uuid)
        .environment(\.managedObjectContext, note.managedObjectContext!)
}
