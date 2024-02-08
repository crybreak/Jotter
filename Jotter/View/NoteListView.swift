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
    @Binding var selectedNoteSorting: NoteSorting
    @EnvironmentObject var stateManager: NavigationStateManager
    
    var selectedFolderTitleBinding: Binding<String> {
        Binding {
            stateManager.selectedFolder?.name ?? ""
        } set: { newValue in
            stateManager.selectedFolder?.name = newValue
        }

    }
    
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
            .listStyleInsertAlternatingBackground()
        }
        .searchable(text: $stateManager.searchText,
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
        .navigationTitle(selectedFolderTitleBinding)
        #if os(iOS)
        .pidNavigationBarTitleDisplayMode()
        #endif
        
        .toolbarTitleMenu(content: {
            RenameButton()
            
            Button(action: {
                
            }, label: {
                Label("Move to", systemImage: "folder")
            })
            
            
            Button(role: .destructive, action: {
                Folder.delete(stateManager.selectedFolder!)
                stateManager.selectedFolder = nil
            }, label: {
                Label("Delete", systemImage: "trash")
            })
        })
        .toolbar {
            
            ToolbarItemGroup(placement: .primaryAction) {
               
#if os(iOS)
                NoteListSortingPicker(selectedNoteSorting: $selectedNoteSorting)
                #endif

            }
            
            ToolbarItemGroup(placement: .addItem) {
#if os(OSX)
                 
                NoteListSortingPicker(selectedNoteSorting: $selectedNoteSorting)
                #endif
               
                Button {
                    stateManager.addNote()
                } label: {
                    Image(systemName: "note.text.badge.plus" )
                }
                .help("Create New Note")
                
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
            NoteListView(selectedNoteSorting: .constant(NoteSorting.creationDateDsc))
               .environment(\.managedObjectContext,
                             context)
               .environmentObject(manager)
               .listStyle(.inset)
        }
        
    }
}
