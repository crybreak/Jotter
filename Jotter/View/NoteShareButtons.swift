//
//  NoteShareButtons.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 01/02/2024.
//

import SwiftUI

struct NoteShareButtons: View {
    @ObservedObject var note: Note
    
    var body: some View {
        if #available(iOS 16.1, *) {
            ShareLink(item: note.attributedStringExport(),
                      preview: SharePreview(note.title))
            .labelStyle(.iconOnly)
            
        }
    }
}

#Preview {
    NoteShareButtons(note: Note.example())
}
