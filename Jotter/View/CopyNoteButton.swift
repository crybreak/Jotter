//
//  CopyNoteButton.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 31/01/2024.
//

import SwiftUI

struct CopyNoteButton: View {
    @ObservedObject var note: Note
    var body: some View {
        
        Button {
            UIPasteboard.general.copyText(note.simpleExport())
        } label: {
            Label("Copy", systemImage: "square.on.square")
        }
        
    }
}
