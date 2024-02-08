//
//  FolderDropPlaceholderCell.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 11/01/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData

struct FolderDropPlaceholderCell: View {
    @Environment(\.managedObjectContext) var viewcontext
    @Environment(\.defaultMinListHeaderHeight) var heigth
    @State private var isTarget: Bool = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(isTarget ? Color.gray : Color.clear)
            .contentShape(Rectangle())
            .onDrop(of: [UTType.jotterFolder]
                    , delegate: FolderDropDelegate(context: viewcontext,
                                                  isTarget: $isTarget))
        
    }
}

private struct FolderDropDelegate: DropDelegate {
    let context: NSManagedObjectContext
    @Binding var isTarget: Bool 
    
    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [UTType.jotterFolder])
    }
    
    func dropEntered(info: DropInfo) {
        guard info.hasItemsConforming(to: [UTType.jotterFolder]) else {return}
        
        let providers = info.itemProviders(for: [UTType.jotterFolder])
        _ = loadFirstFolder(providers: providers) { droppedFolder in
            if droppedFolder.parent != nil {
                isTarget = true
            }
        }
        
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        print("location : \(info.location)")
        
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        let providers = info.itemProviders(for: [UTType.jotterFolder])
        return loadFirstFolder(providers: providers) { droppedFolder in
            droppedFolder.parent = nil
        }
    }
    
    func dropExited(info: DropInfo) {
        isTarget = false
    }
    
    func loadFirstFolder(providers: [NSItemProvider], using load: @escaping (Folder) -> Void) -> Bool {
        providers.loadFirstObject(ofType: FolderDragItem.self) {droppedFolderItem in
            if let uuid = droppedFolderItem.id,
               let droppedFolder = Folder.fetch(uuid, context: context) {
                load(droppedFolder)
            }
        }
    }
}

#Preview {
    FolderDropPlaceholderCell()
}
