//
//  NotesKeywordsCollectView.swift
//  Jotter
//
//  Created by macbook on 20/11/2023.
//

import SwiftUI

struct NotesKeywordsCollectView: View {
    
    @ObservedObject var note: Note;
    
    init(note: Note) {
        self.note = note
        self._keywords = FetchRequest(fetchRequest: Keyword.fetch(for: note))
    }
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(fetchRequest: Keyword.fetch(.none))
    
    var keywords: FetchedResults<Keyword>
    var body: some View {
        FlowLayout (alignment: .leading, spacing: 2) {
            ForEach(keywords) {keyword in
                HStack {
                    Image(systemName: "tag.fill")
                        .foregroundColor(keyword.color)
                    Text(keyword.name)
                }.padding(5)
                    .background(RoundedRectangle(cornerRadius: 5)
                        .fill(colorScheme == .dark ?  Color(white: 0)
                              : Color(white: 0.9)))
                    .contextMenu{
                        Button("Remove Keyword") {
                            note.keywords.remove(keyword)
                        }
                        
                        Button("show notes for keyword ") {
                            
                        }
                    }
            }
        }
    }
}

struct NotesKeywordsCollectView_Previews: PreviewProvider {
    static var previews: some View {
        NotesKeywordsCollectView(note: Note.example())
            .environment(\.managedObjectContext,
            PersistenceController.preview.container.viewContext)
    }
}
