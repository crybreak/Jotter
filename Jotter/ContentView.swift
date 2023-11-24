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
    
    @State private var columnVisibility:
    NavigationSplitViewVisibility = .all
    
    @State private var selectedFolder: Folder? = nil
    @State private var selectedNote: Note? = nil
    var body: some View {
        NavigationSplitView(columnVisibility:
                                $columnVisibility) {
            FolderListView(selectedFolder: $selectedFolder)
        } content: {
            if let folder = selectedFolder {
                NoteListView(selectedFolder: folder, selectNote: $selectedNote)
            } else {
                Text("select folder")
                    .foregroundColor(.secondary)
            }
        } detail: {
            if let note = selectedNote {
                ContentDetailNote(note: note)
            } else {
                Text("select a note")
                    .foregroundColor(.secondary)
            }
        }
        
        
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
