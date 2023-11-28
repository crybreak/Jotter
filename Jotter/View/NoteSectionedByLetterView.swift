//
//  NoteSectionedByLetter.swift
//  Jotter
//
//  Created by macbook on 28/11/2023.
//

import SwiftUI
import CoreData

struct NoteSectionedByLetterView: View {
    
    init(for selectedFolder: Folder) {
        self.selectedFolder = selectedFolder
        let request = Note.fetch(for: selectedFolder)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.title_, ascending: true)]
        self._sectionByLetter = SectionedFetchRequest(fetchRequest: request,
                                                      sectionIdentifier: \.sectionLetterTitle)
    }
    
    let selectedFolder: Folder
    @Environment(\.managedObjectContext) var context
    
    @SectionedFetchRequest<String, Note>(
        sectionIdentifier: \.sectionLetterTitle,
        sortDescriptors:[SortDescriptor(\.title_)] )
    
    private var sectionByLetter: SectionedFetchResults<String, Note>
    var body: some View {
        ForEach(sectionByLetter) {section in
            Section (section.id) {
                ForEach (section) {note in
                    NoteRow(note: note)
                        .tag(note)
                }.onDelete {offset in
                    deleteNotes(section: section, offsets: offset)
                }
            }
        }
    }
    
    private func deleteNotes(section: SectionedFetchResults<String, Note>.Element ,offsets: IndexSet) {
        offsets.map { section[$0] }.forEach(Note.delete(note:))
    }
}

struct NoteSectionedByLetterView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = Folder.exampleWithNotes(context: context)
        
        
        return NavigationView {
            NoteSectionedByLetterView(for: folder)
                .environment(\.managedObjectContext, context)
        }
    }
}
