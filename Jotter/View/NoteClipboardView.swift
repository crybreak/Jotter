//
//  NoteClipboardView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 03/02/2024.
//

import SwiftUI
import CoreData

struct NoteClipboardView: View {
    @EnvironmentObject var clipboard: LinkedNoteClipboard
    @Environment(\.dismiss) var dismiss

    @ObservedObject var note: Note
    var filterNoteIds: [UUID] {
        clipboard.noteIds.filter{$0 != note.uuid}
    }
    
    @State private var selectedNote: Set<Note> = []
    
    var body: some View {
        NavigationView{
            VStack {
                List (selection: $selectedNote) {
                    ForEach(filterNoteIds, id: \.self) { id in
                        NoteIdRow(uuid: id)
                    }
                }
                .listStyle(.inset)
                HStack (spacing: 20) {
                    Button(action: {dismiss()}, label: {
                        Text("Cancel")
                    })
                    .buttonStyle(.bordered)
                    
                    
                    Button(action: {
                        selectedNote.forEach { link in
                            note.linkedNotes.insert(link)
                        }
                        dismiss()
                    }, label: {
                        Text("Add")
                    }).buttonStyle(.borderedProminent)
                        .disabled(selectedNote.count == 0)
                    
                }
            }
            .padding()
            .navigationTitle("Notes in your clipboard")
            .toolbar {
                EditButton()
            }
            .pidNavigationBarTitleDisplayMode()

            
        }
        
    }
}

private struct NoteIdRow: View {
    init(uuid: UUID) {
        let request = Note.createFetchRequest(uuid)
        self._notes = FetchRequest(fetchRequest: request)
    }
    
    @FetchRequest(fetchRequest: Note.fetch(.none))
    var notes: FetchedResults<Note>
    
    var body: some View {
        if let note = notes.first {
            Text(note.title)
                .tag(note)
        }
    }
}

#Preview {
    NavigationView {
        Group  {
            NoteClipboardView(note: Note.example())
                .environmentObject(LinkedNoteClipboard.preview())
                .previewDisplayName("With links")
            
    //        NoteClipboardView(note: Note.example())
    //            .environmentObject(LinkedNoteClipboard())
    //            .previewDisplayName("Empty links")
           
        }
    }
   
    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

}
