//
//  RecursiveFolderView.swift
//  Jotter
//
//  Created by macbook on 19/11/2023.
//

import SwiftUI

struct RecursiveFolderView: View {
    
    @ObservedObject var folder: Folder
    @State private var showSubfolders: Bool = false
    
    var body: some View {
            HStack {
                Image(systemName: "folder")
                FolderRow(folder: folder)
                
                Spacer()
                if folder.children.count > 0 {
                    Button {
                        withAnimation {
                            showSubfolders.toggle()
                        }
                    } label: {
                        Image(systemName:   "chevron.right")
                            .rotationEffect(.init(degrees: showSubfolders ? 90 : 0))
                    }
                }
            }.tag(folder)
        if showSubfolders {
            ForEach(folder.children.sorted()) { subFolder in
                RecursiveFolderView(folder: subFolder)
                    .padding(.leading)
            }.onDelete(perform: deleteFolders(offsets:))
        }
    }
    private func deleteFolders(offsets: IndexSet) {
        offsets.map { folder.children.sorted()[$0] }.forEach(Folder.delete(_:))
    }
}

//struct RecursiveFolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        List {
//            RecursiveFolderView(folder: Folder.nestedFolderExemple(context: PersistenceController.preview.container.viewContext))
//        }
//       
//    }
//}
