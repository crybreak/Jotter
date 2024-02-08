//
//  LinkedNotesView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 09/01/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct LinkedNotesView: View {
    @ObservedObject var note: Note
    @EnvironmentObject var stateManager: NavigationStateManager
    @Environment(\.managedObjectContext) var viewContext
    @State private var isTargeted = false

    
    var body: some View {
        HStack (alignment: .firstTextBaseline) {
            Text("Linked Notes: ")
                .bold()
            VStack (alignment: .leading, spacing: 5){
                ForEach(note.linkedNotes.sorted()) {note in
                    Button(action: {
                        #if os(OSX)
                        stateManager.noteChanged(to: note)
                        #else
                        stateManager.noteAppendToNavigationStack(note: note)
                        #endif
                    }, label: {
                        Text(note.title)
                    })
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay(isTargeted ? Color(white: 0.5, opacity: 0.5) :
                    Color.clear)
        .onDrop(of: [UTType.jotterNote], isTargeted: $isTargeted,
                perform: { providers in
            handleDrop(for: providers )
        })
    }
        
    
    func handleDrop(for providers: [NSItemProvider]) -> Bool{
        
        let found = providers.loadFirstObject(ofType: NoteDragItem.self) {
            NoteDragItem in
            guard let id = NoteDragItem.id,
                  let droppedNote = Note.fetch(id, context: viewContext) else {
                return
            }
            
            guard note.uuid != droppedNote.uuid else {return}
            note.linkedNotes.insert(droppedNote)
        }
        return found

    }
}

#Preview {
    return NavigationView {
        LinkedNotesView(note: Note.example())
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
            .environmentObject(NavigationStateManager())
    }
   
}
