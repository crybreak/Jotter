//
//  ContentView.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.scenePhase) var scenePhase
    
    @State private var columnVisibility:
    NavigationSplitViewVisibility = .all
    
    @StateObject var stateManager = NavigationStateManager()
    
    @SceneStorage("folder") var folderID: String?
    @SceneStorage("note") var noteID: String?
    
    var body: some View {
        NavigationSplitView(columnVisibility:
                                $columnVisibility) {
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
        }
        .environmentObject(stateManager)
        .focusedSceneObject(stateManager)
        .onReceive (stateManager.$selectedNote.compactMap({$0}) ) {note  in
            noteID = note.uuid.uuidString
        }
        .onReceive (stateManager.$selectedFolder.compactMap({$0})) {folder  in
            folderID = folder.uuid.uuidString
        }
        
        .onChange(of: noteID, perform: { newValue in
            restoreState()
        })
        
        .onChange(of: scenePhase) { newValue in
            guard newValue == .active else {return}
            restoreState()
         

        }
    }
    
    func restoreState() {
        stateManager.restoreState(noteID: noteID, folderID: folderID, context: viewContext)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
