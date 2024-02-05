//
//  EditlinkedNoteView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 03/02/2024.
//

import SwiftUI

struct EditlinkedNoteView: View {
    @EnvironmentObject var clipboard: LinkedNoteClipboard

    @ObservedObject var note: Note
    @State private var showClipboard = false
    @State private var selectionDetent: PresentationDetent = .medium
    
    var noteIsClipboard: Bool {
        clipboard.noteIds.contains{$0 == note.uuid}
    }
    var body: some View {
        Menu {
            if noteIsClipboard {
                Label("Note added to clipboard", systemImage: "checkmark")
            } else {
                
                Button(action: {
                    clipboard.addNote(note)
                }, label: {
                    Text("Copy Note to Clipboard")
                })
            }
            Button(action: {
                showClipboard.toggle()
            }, label: {
                Text("Insert Note from Clipboard")
            })
        } label: {
            Label("Insert Link", systemImage: "link")
        }
        .sheet(isPresented: $showClipboard, content: {
            NoteClipboardView(note: note)
                .presentationDetents([.fraction(0.25) , .medium],
                selection: $selectionDetent)
//                .presentationDragIndicator(.visible)
        })
    }
}

#Preview {
    EditlinkedNoteView(note: Note.example())
        .environmentObject(LinkedNoteClipboard.preview())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
