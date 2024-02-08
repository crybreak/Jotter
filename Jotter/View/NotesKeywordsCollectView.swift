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
    @FetchRequest(fetchRequest: Keyword.fetch(.none))
        
    var keywords: FetchedResults<Keyword>
    
    @State private var isHovering = false

    var body: some View {
        HStack (alignment: .firstTextBaseline){
            Text  ("Keywords: ")
                .bold()
            FlowLayout (alignment: .leading, spacing: 2) {
                ForEach(keywords) {keyword in
                    KeywordCellView(keyword: keyword)
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
}

struct NotesKeywordsCollectView_Previews: PreviewProvider {
    static var previews: some View {
        NotesKeywordsCollectView(note: Note.example())
            .environment(\.managedObjectContext,
            PersistenceController.preview.container.viewContext)
    }
}

private struct KeywordCellView: View {
    
    var keyword: Keyword
    @State private var isHovering = false
    
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        HStack {
            Image(systemName: "tag.fill")
                .foregroundColor(keyword.color)
            Text(keyword.name)
            if (isHovering) {
                Text("\(keyword.notes.count)")
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 5)
            .fill(colorScheme == .dark ?  Color(white: 0)
                  : Color(white: 0.9)))
        .onHover(perform: { isHovering in
            withAnimation {
                self.isHovering = isHovering
            }
            #if os(OSX)
            if isHovering {
                NSCursor.pointingHand.push()
               
            } else {
                NSCursor.pop()
            }
            #endif
        })
    }
}
