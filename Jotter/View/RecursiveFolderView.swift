//
//  RecursiveFolderView.swift
//  Jotter
//
//  Created by macbook on 19/11/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct RecursiveFolderView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    @ObservedObject var folder: Folder
    @State private var showSubfolders: Bool = false
    @State private var isTargted: Bool = false
    
    var body: some View {
            HStack {
                Group {
                    FolderRow(folder: folder)
                    
                    Spacer()
                    if (folder.notes.count > 0) {
                        Text("\(folder.notes.count)")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    stateManager.folderChanged(to: folder)
                }
                
                Button {
                    withAnimation {
                        showSubfolders.toggle()
                    }
                } label: {
                    Image(systemName:   "chevron.right")
                        .rotationEffect(.init(degrees: showSubfolders ? 90 : 0))
                        .padding(.horizontal)
                }
                .foregroundColor(.accentColor)
                .opacity(folder.children.count > 0 ? 1 : 0)
            }.tag(folder)
            .padding(.bottom, isTargted ? 10 : 0)
            .overlay(alignment: .bottom) {
                Color("SecondaryColor")
                    .frame(height: 2)
                    .opacity(isTargted ? 1 : 0)
            }
            .onDrop(of: [UTType.jotterNote, UTType.jotterFolder], isTargeted: $isTargted.animation(), perform: { providers in
                folder.handle(providers: providers)
            })
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

struct RecursiveFolderView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RecursiveFolderView(folder: Folder.nestedFolderExemple(context: PersistenceController.preview.container.viewContext))
        }
       
    }
}
