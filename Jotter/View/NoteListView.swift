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
    
    @StateObject var viewModel = NoteSearchViewModel()
    
    var body: some View {
        List (selection: $selectedNote){
            switch selectedNoteSorting {
            case .titleAsc, .titleDsc, .creationDateAsc, .creationDateDsc:
                NoteSingleSortedView(predicate: viewModel.predicate, noteSorting: selectedNoteSorting)
            case .status:
                NoteSectionedByStatusView(predicate: viewModel.predicate)
            case .day:
                NoteSectionbYDayView(predicate: viewModel.predicate)
            case .letter:
                NoteSectionedByLetterView(predicate: viewModel.predicate)
            }
        }.searchable(text: $viewModel.searchText,
                     tokens: $viewModel.searchTokens,
                     token: { token in
            Text(token.name)
        })
        .searchSuggestions({
            ForEach(NoteSearchToken.allCases) {token in
                Button {
                     viewModel.addToken(token)
                } label: {
                    Text(token.fullName)
                }.disabled(viewModel.isTokenSelected(token))

            }
        }).searchScopes($viewModel.searchScope, scopes: {
            ForEach(NoteSearchScope.allCases) {scope in
                Text(scope.name(folder: selectedFolder))
            }
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
        }.onAppear {
            viewModel.folderChanged(to: selectedFolder)
        }
        .onChange(of: selectedFolder) { newValue in
            viewModel.folderChanged(to: selectedFolder)
        }
    }
    
    
    
    private func addNote() {
        let newNote = Note(title: "New note1", context: viewContext)
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
