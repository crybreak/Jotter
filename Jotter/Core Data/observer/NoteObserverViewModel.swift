//
//  NoteObserverViewModel.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 07/02/2024.
//

import Foundation
import CoreData

class NoteObserverViewModel: NSObject {
    
    let context: NSManagedObjectContext
    
    var fetchResultsController: NSFetchedResultsController<Note>? = nil
    
    @Published var deleteNote: Note? = nil
    @Published var isUpdatingFetch: Bool = false
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        createResultController(with: context)
        startFetching()
    }
    
    func createResultController(with context: NSManagedObjectContext) {
        let fetchRequest = Note.fetch(.all)
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        self.fetchResultsController = controller
        
    }
    
    func startFetching() {
        guard let controller = fetchResultsController else {return}
        
        do {
            try controller.performFetch()
        } catch {
            print("Unable to Perform Fetch Request for notes: \(error)")
        }
    }
}

extension NoteObserverViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        isUpdatingFetch = true
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        guard let note = anObject as? Note else {return}

        switch type {
        case .insert:
            return
        case .delete:
            self.deleteNote = note
        case .move:
            return
        case .update:
            return
        @unknown default:
            fatalError()
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        isUpdatingFetch = false
    }
    
}
