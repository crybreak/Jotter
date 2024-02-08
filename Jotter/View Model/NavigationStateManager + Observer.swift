//
//  NavigationStateManager + Observer.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 07/02/2024.
//

import CoreData
import Combine

extension NavigationStateManager {
    
    func createNoteObserverTrigger() {
        
        let context = PersistenceController.shared.container.viewContext
        noteObserver = NoteObserverViewModel(context: context)
        
        noteObserver?.$deleteNote.sink(receiveValue: { [unowned self] deletedNote in

            if self.selectedNote?.uuid == deletedNote?.uuid {
                self.selectedNote = nil
            }
            
            if let index =  self.path.firstIndex(where: {$0.uuid == deletedNote?.uuid}) {
                self.path.remove(at: index)
            }
        })
        .store(in: &subscriptions)
    }
    
    func createFolderObserverTrigger() {
        
        let context = PersistenceController.shared.container.viewContext
        folderObserver = FolderObserverViewModel(context: context)
        
        folderObserver?.$deleteFolder.sink(receiveValue: { [unowned self] deletedFolder in

            if self.selectedFolder?.uuid == deletedFolder?.uuid {
                self.selectedFolder = nil
            }
        })
        .store(in: &subscriptions)
    }
}

