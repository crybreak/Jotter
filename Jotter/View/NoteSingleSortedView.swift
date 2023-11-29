//
//  NoteSingleSorted.swift
//  Jotter
//
//  Created by macbook on 27/11/2023.
//

import SwiftUI

struct NoteSingleSortedView: View {
    
    init(selectedFolder: Folder, noteSorting: NoteSorting) {
        self.selectedFolder = selectedFolder
        self._notes = FetchRequest(fetchRequest: Note.fetch(for: selectedFolder))
        self.noteSorting = noteSorting
    }
    
    @FetchRequest(fetchRequest: Note.fetch(.none))
    private var notes: FetchedResults<Note>

    let selectedFolder: Folder
    var noteSorting: NoteSorting
    
    var body: some View {
        
        ForEach(notes) { note in
            NavigationLink(value: note) {
                NoteRow(note: note)
            }.tag(note)
        }.onDelete(perform: deleteNotes(offsets:))
        
        .onChange(of: noteSorting) { newValue in
            
            let defaultSorting = NSSortDescriptor(keyPath: \Note.creationDate_,
                                                  ascending: true)
            switch newValue {
            case .creationDateAsc:
                notes.nsSortDescriptors = [defaultSorting]
            case .creationDateDsc:
                notes.nsSortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate_, ascending: false)]
            case .titleAsc:
                notes.nsSortDescriptors = [NSSortDescriptor(keyPath: \Note.title_, ascending: true), defaultSorting]
            case .titleDsc:
                notes.nsSortDescriptors = [NSSortDescriptor(keyPath: \Note.title_, ascending: false), defaultSorting ]
            default:
                return
                
            }
        }
    }
    
    private func deleteNotes(offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(Note.delete(note:))
    }
}

struct NoteSingleSorted_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        
        NoteSingleSortedView(selectedFolder: Folder.exampleWithNotes(context: context),
                         noteSorting: NoteSorting.creationDateDsc)
            .environment(\.managedObjectContext, context)
    }
}
