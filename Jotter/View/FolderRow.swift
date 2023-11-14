//
//  FolderRow.swift
//  Jotter
//
//  Created by macbook on 13/11/2023.
//

import SwiftUI

struct FolderRow: View {
    
    @ObservedObject var folder: Folder
    @State private var showDeleteConfirmation: Bool = false

    var body: some View {
        TextField("", text: $folder.name)
            .textFieldStyle(.roundedBorder)
            .contextMenu {
                Button ("Rename") {
                }
                
                Button("Delete") {
                    showDeleteConfirmation = true
                }
            }
            .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
                Button("Delete") {
                    Folder.delete(folder)
                }
            }
    }
}

