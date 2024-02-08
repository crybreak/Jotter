//
//  NotePathFolder.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 05/02/2024.
//

import SwiftUI

struct NotePathFolderView: View {
     
    enum Style {
        case hstack
        case flowlayout
    }
    
    let style: Style
    
    @ObservedObject var note: Note
    var body: some View {
        if let folders = note.folder?.fullFolderPath() {
            switch style {
            case .hstack:
                HStack  {
                    ForEach(folders) {folder in
                        FolderCell(folder: folder)
                    }
                }
            case .flowlayout:
                FlowLayout (alignment: .leading) {
                    ForEach(folders) {folder in
                        FolderCell(folder: folder)
                    }
                }
            }
           
        }
    }
}

private struct FolderCell: View {
    @ObservedObject var folder: Folder
    @EnvironmentObject var stateManager: NavigationStateManager


    var body: some View {
        HStack (spacing: 2) {
            Image(systemName: "chevron.forward")
            Image(systemName: "folder")
            Text(folder.name)
        }.onTapGesture {
            withAnimation {
                stateManager.folderChanged(to: folder)
            }
        }
    }
}

#Preview {
    NotePathFolderView(style: .hstack, note: Note.exampleLongFolder())
        .previewDisplayName("folder path")
        .environmentObject(NavigationStateManager())
}
