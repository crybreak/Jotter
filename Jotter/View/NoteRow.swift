//
//  NoteRow.swift
//  Jotter
//
//  Created by macbook on 15/11/2023.
//

import SwiftUI

struct NoteRow: View {
    @ObservedObject var note: Note
    
    var body: some View {
        VStack (alignment: .leading){
            Text(note.title)
                .bold()
            
            Text(note.creationDate, formatter: itemFormatter)
                .font(.caption)
            
            if note.bodyText.count > 0 {
                Text(note.bodyText)
                    .lineLimit(3)
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct NoteRow_Previews: PreviewProvider {
    static var previews: some View {
        NoteRow(note: Note(title: "new Note",
                           context: PersistenceController.preview.container.viewContext))
    }
}
