//
//  FolderEditorView.swift
//  Jotter
//
//  Created by macbook on 15/11/2023.
//

import SwiftUI

struct FolderEditorView: View {
    
    @ObservedObject var folder: Folder
    
    init(folder: Folder ) {
        self.folder = folder
        self._name = State(initialValue: folder.name)
    }
    @State private var name: String = "";
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack (spacing: 30) {
            
            Text("Rename Folder")
                .font(.title)
            
            TextField("name", text: $name)
                .textFieldStyle(.roundedBorder)
            
            HStack (spacing: 30) {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                Button("Save") {
                    folder.name = name
                    PersistenceController.shared.save()
                    dismiss()
                }
                
            }
        }
    }
}

struct FolderEditorView_Previews: PreviewProvider {
    static var previews: some View {
        FolderEditorView(folder: Folder(name: "name", context: PersistenceController.preview.container.viewContext))
    }
}
