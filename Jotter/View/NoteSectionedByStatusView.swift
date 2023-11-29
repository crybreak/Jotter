//
//  NoteSectionedByStatusView.swift
//  Jotter
//
//  Created by macbook on 27/11/2023.
//

import SwiftUI

struct NoteSectionedByStatusView: View {
    
    init(predicate: NSPredicate) {
        let request = Note.fetch(predicate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.status_, ascending: true), NSSortDescriptor(keyPath: \Note.creationDate_, ascending: true)]
        
        self._sectionedNotes = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.sectionStatus)
    }
    
    @SectionedFetchRequest<String, Note>(
        sectionIdentifier: \.sectionStatus,
        sortDescriptors: [SortDescriptor(\.status_)]
    )
    
    private var sectionedNotes: SectionedFetchResults<String, Note>
    
    var body: some View {
        ForEach(sectionedNotes) {section in
            Text(section.id)
                .font(.title3)
                .foregroundColor(.gray)
                .padding(.top)
                .bold()
            
            ForEach(section) { note in
                NoteRow(note: note)
                    .tag(note)
            }
            .onDelete { offset in
                deleteNotes(section: section, offsets: offset)
            }
        }       
    }
    
    private func deleteNotes(section: SectionedFetchResults<String, Note>.Element ,offsets: IndexSet) {
        offsets.map { section[$0] }.forEach(Note.delete(note:))
    }
}

struct NoteSectionedByStatusView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let folder = Folder.exampleWithNotes(context: context)
        
        let viewModel = NoteSearchViewModel()
        viewModel.folderChanged(to: folder)
        let predicate = viewModel.predicate
        
        return NoteSectionedByStatusView(predicate: predicate)
            .environment(\.managedObjectContext, context)
    }
}
