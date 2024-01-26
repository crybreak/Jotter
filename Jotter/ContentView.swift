//
//  ContentView.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.undoManager) private var undoManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    @StateObject var stateManager = NavigationStateManager()
    
    @SceneStorage(SceneStorageKeys.folder) var folderID: String?
    @SceneStorage(SceneStorageKeys.note) var noteID: String?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
                        
            FolderListView(selectedFolder: $stateManager.selectedFolder)
        } content: {
            if  stateManager.selectedFolder != nil {
                NoteListView()
            } else {
                Text("select folder")
                    .foregroundColor(.secondary)
            }
        } detail: {
            if let note = stateManager.selectedNote {
                ContentDetailNote(note: note)
            } else {
                Text("select a note")
                    .foregroundColor(.secondary)
            }
        }.toolbar(content: {
            ToolbarItem(placement: .navigation) {
                NavigationBackwardForwardButtonsView()
            }
        })
        .environmentObject(stateManager)
        .focusedSceneObject(stateManager)
        .onReceive (stateManager.$selectedNote.dropFirst()) {note  in
            noteID = note?.uuid.uuidString
        }
        .onReceive (stateManager.$selectedFolder.dropFirst()) {folder  in
            folderID = folder?.uuid.uuidString
        }
        
        // need for macos for window in background
        .onChange(of: noteID, perform: { newValue in
            restoreState()
        })
        
        // need for ios

        .onChange(of: scenePhase) { newValue in
            guard newValue == .active else {return}
            restoreState()
        }
        
        .onChange(of: undoManager) { newValue in
            stateManager.undoManager = newValue
        }
        
    }
    
    func restoreState() {
        stateManager.restoreState(noteID: noteID, folderID: folderID, context: viewContext)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
