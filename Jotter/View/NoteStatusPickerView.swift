//
//  NoteStatusPickerView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 29/01/2024.
//

import SwiftUI

struct NoteStatusPickerView: View {
    @ObservedObject var note: Note
    var body: some View {
        
        Picker(selection: $note.status) {
            ForEach(Status.allCases) {status in
                Text(status.rawValue)
                    .tag(status)
            }
        } label: {
            Text("Note's status")
        }
    }
}

#Preview {
    NoteStatusPickerView(note: Note.example())
}
