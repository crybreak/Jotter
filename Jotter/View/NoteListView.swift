//
//  NoteListView.swift
//  Jotter
//
//  Created by macbook on 13/11/2023.
//

import SwiftUI
import CoreData

struct NoteListView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @State private var selectedNoteSorting = NoteSorting.creationDateAsc
    
    @EnvironmentObject var stateManager: NavigationStateManager
    
    var body: some View {
        
        UndoProvider($stateManager.selectedNote) { binding in
            List (selection: binding){
                switch selectedNoteSorting {
                case .titleAsc, .titleDsc, .creationDateAsc, .creationDateDsc:
                    NoteSingleSortedView(predicate: stateManager.predicate, noteSorting: selectedNoteSorting)
                case .status:
                    NoteSectionedByStatusView(predicate: stateManager.predicate)
                case .day:
                    NoteSectionbYDayView(predicate: stateManager.predicate)
                case .letter:
                    NoteSectionedByLetterView(predicate: stateManager.predicate)
                }
            }
        }.searchable(text: $stateManager.searchText,
                     tokens: $stateManager.searchTokens,
                     token: { token in
            Text(token.name)
        })
        .searchSuggestions({
            ForEach(NoteSearchToken.allCases) {token in
                Button {
                     stateManager.addToken(token)
                } label: {
                    Text(token.fullName)
                }.disabled(stateManager.isTokenSelected(token))

            }
        }).searchScopes($stateManager.searchScope, scopes: {
            ForEach(NoteSearchScope.allCases) {scope in
                Text(scope.name(folder: stateManager.selectedFolder!))
            }
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: stateManager.addNote) {
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
}



struct NoteListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let folder = Folder.exampleWithNotes(context: context)
        let manager = NavigationStateManager()
        manager.selectedFolder = folder
        return NavigationView {
            NoteListView()
               .environment(\.managedObjectContext,
                             context)
        }.environmentObject(manager)
        
    }
}
