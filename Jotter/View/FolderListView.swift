//
//  FolderListView.swift
//  Jotter
//
//  Created by macbook on 13/11/2023.
//

import SwiftUI

struct FolderListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(fetchRequest: Folder.topFolderFetch())
    private var folders: FetchedResults<Folder>
    
    @Binding var selectedFolder: Folder?
    @EnvironmentObject var stateManager: NavigationStateManager
    
    @State private var showSettings: Bool = false
    
//    var addNewButtonPlacement: ToolbarItemPlacement {
//        #if os(iOS)
//        .status
//        #else
//        .primaryAction
//        #endif
//    }
//    
    var body: some View {
     
        UndoProvider($selectedFolder) { binding in
            List (selection: binding) {
                ForEach(folders) { folder in
                    RecursiveFolderView(folder: folder)
                }
                .onDelete(perform: deleteFolders(offsets:))
                #if os(iOS)
                .listRowInsets(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
                #endif
                #if os(OSX)
                FolderDropPlaceholderCell()
                #endif
            }
            #if os(iOS)
            .listStyle(.plain)
            #endif
        }
        .navigationTitle("Jotter")
        .toolbar {
            ToolbarItem(placement: .addItem) {
                Button {
                    stateManager.addFolder()
                } label: {
                    Label("Create new folder", systemImage: "folder.badge.plus")
                    #if os(iOS)
                        .labelStyle(.titleAndIcon)
                    #endif
                }
                .help("Create New Folder")
            }
            #if os(iOS)
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showSettings.toggle()
                }label: {
                    Label("Settings", systemImage: "gear")
                }
                .sheet(isPresented: $showSettings, content: {
                    Text("Show settings")
                })
            }
            #endif
        }
        .navigationTitle("Jotter")
    }
    
    private func deleteFolders(offsets: IndexSet) {
        offsets.map { folders[$0] }.forEach(Folder.delete(_:))
    }
}

struct FolderList_Previews: PreviewProvider {
    static var previews: some View {
        let context =  PersistenceController.createEmptyStore().container.viewContext
        let nestedFolder = Folder.nestedFolderExemple(context: context)
        NavigationView {
            FolderListView(selectedFolder: .constant(nestedFolder))
                .environment(\.managedObjectContext, context)
                .environmentObject(NavigationStateManager())

        }
    }
}
