//
//  NoteListView.swift
//  Jotter
//
//  Created by macbook on 13/11/2023.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    
    init(selectedFolder: Folder, selectedNote: Binding<Note?>) {
        self.selectedFolder = selectedFolder
        self._selectedNote = selectedNote
    }
    
    let selectedFolder: Folder
    @Binding var selectedNote: Note?
    @Environment(\.managedObjectContext) var viewContext        
    @State private var selectedNoteSorting = NoteSorting.creationDateAsc
    @State private var searchText: String = ""
    @State private var searchTokens = [NoteSearchToken]()
    @State private var searchTokenSuggestions = NoteSearchToken.allCases

    var body: some View {
        List (selection: $selectedNote){
            switch selectedNoteSorting {
            case .titleAsc, .titleDsc, .creationDateAsc, .creationDateDsc:
                NoteSingleSortedView(selectedFolder: selectedFolder, noteSorting:    selectedNoteSorting)
            case .status:
                NoteSectionedByStatusView(selectedFolder: selectedFolder)
            case .day:
                NoteSectionbYDayView(selectedFolder: selectedFolder)
            case .letter:
                NoteSectionedByLetterView(for: selectedFolder)
            }
        }.searchable(text: $searchText,
                     tokens: $searchTokens,
                     suggestedTokens: $searchTokenSuggestions, token: { token in
            Text(token.name)
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: addNote) {
                    Label("New Note", systemImage: "note.text.badge.plus" )
                }
            }
            
            ToolbarItem (placement: .secondaryAction)  {
                Picker("Sort By", selection: $selectedNoteSorting.animation()) {
                    ForEach(NoteSorting.allCases) {sorting in
                        Text(sorting.title())
                    }
                }
            }
        }
    }
    
    
    
    private func addNote() {
        let newNote = Note(title: "New note", context: viewContext)
        newNote.folder = selectedFolder
        selectedNote = newNote
    }
}



struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let folder = Folder.exampleWithNotes(context: context)
        return NavigationView {
            NoteListView(selectedFolder: folder, selectedNote: .constant(nil))
               .environment(\.managedObjectContext,
                             context)
        }
        
    }
}
