//
//  NoteSectionbYDayView.swift
//  Jotter
//
//  Created by macbook on 27/11/2023.
//

import SwiftUI

struct NoteSectionbYDayView: View {
    
    init(predicate: NSPredicate) {
        let request = Note.fetch(predicate)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate_, ascending: false)]
        self._notesSections = SectionedFetchRequest(fetchRequest: request, sectionIdentifier: \.day)
    }
    
    @SectionedFetchRequest<String, Note>(
        sectionIdentifier: \.day,
        sortDescriptors: [SortDescriptor(\.creationDate_, order: .forward)]
    )
    
    private var notesSections: SectionedFetchResults<String, Note>
    var body: some View {
       
            ForEach(notesSections) {section in
                
                Text(section.id)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .padding(.top)
                
                ForEach(section) {note in
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

//struct NoteSectionbYDayView_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        let context = PersistenceController.preview.container.viewContext
//        let folder = Folder.exampleWithNotes(context: context)
//        
//        let viewModel = NavigationStateManager()
//        viewModel.folderChanged(to: folder)
//        let predicate = viewModel.predicate
//        
//        viewModel.searchTokens = [.draftStatus, .last24Hours]
//
//        
//        return NoteSectionbYDayView(predicate: predicate)
//            .environment(\.managedObjectContext, context)
//    }
//}
