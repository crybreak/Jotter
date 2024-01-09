//
//  FolderRow.swift
//  Jotter
//
//  Created by macbook on 13/11/2023.
//

import SwiftUI

struct FolderRow: View {
    
    @ObservedObject var folder: Folder
    @Environment(\.managedObjectContext) var viewContext;

    @State private var showRenameEditor: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @FocusState private var textFieldIsSelected: Bool

    var body: some View {
        Group {
#if os(iOS)
            Text(folder.name)
#else
            TextField("", text: $folder.name)
                .focused($textFieldIsSelected)
#endif
        }
        .contextMenu {
            Button ("Rename") {
                #if os(OSX)
                textFieldIsSelected = true
                #else
                showRenameEditor = true
                #endif
            }
            Button  {
                let subfolder = Folder(name: "New subFolder",
                                       context: viewContext)
                folder.children.insert(subfolder)
            } label: {
                Text("Create New Subfolder")
            }

            Button("Delete") {
                showDeleteConfirmation = true
            }
        }
        .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
            Button("Delete") {
                Folder.delete(folder)
                PersistenceController.shared.save()
            }
        }
        .sheet(isPresented: $showRenameEditor) {
            FolderEditorView(folder: folder)
        }
    }
}

struct FolderRow_Previews: PreviewProvider {
    static var previews: some View {
        FolderRow(folder: Folder(name: "New Folda", context:
                                    PersistenceController.shared.container.viewContext))
        .frame(width: 200)
        .padding(50)
        
        
        
    }
}

