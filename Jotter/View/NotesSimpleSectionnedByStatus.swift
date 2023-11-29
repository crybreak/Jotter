//
//  NotesSimpleSectionnedByStatus.swift
//  Jotter
//
//  Created by macbook on 27/11/2023.
//

import SwiftUI

struct NotesSimpleSectionnedByStatus: View {

    let selectedFolder: Folder
    var body: some View {
        List {
            ForEach(Status.allCases.reversed()) {status in
                sectionedView (selectedFolder: selectedFolder,
                               status: status, title: status.rawValue )
            }
        }
    }
}

fileprivate struct sectionedView: View {
    
    let title: String
    
    init(selectedFolder: Folder, status: Status, title: String) {
        self.title = title
        self._notes = FetchRequest(fetchRequest: Note.fetch(for: selectedFolder, status: status))
    }
    
    @FetchRequest(fetchRequest: Note.fetch(.none))

    private var notes: FetchedResults<Note>
    var body: some View {
        Section(self.title) {
            ForEach(notes) {note in
                NoteRow(note: note)
            }
        }
    }
}
struct NotesSimpleSectionnedByStatus_Previews: PreviewProvider {
    static var previews: some View {
        
        let context = PersistenceController.preview.container.viewContext
        let folder = Folder.exampleWithNotes(context: context)
        
        return NotesSimpleSectionnedByStatus (selectedFolder: folder ).environment(\.managedObjectContext, context)
    }
}
