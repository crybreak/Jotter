//
//  NoteFileExporterButton.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 01/02/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct NoteFileExporterButton: View {
    
    @ObservedObject var note: Note
    @Binding  var showExportDialog: Bool
    
    var body: some View {
        Button(action: {
            showExportDialog.toggle()
        }, label: {
            Label("Export to files", systemImage: "square.and.arrow.up")
        })
        .labelStyle(.iconOnly)
    }
}

struct NoteFileExportModifier: ViewModifier {
    @ObservedObject var note: Note
    @Binding  var showExportDialog: Bool
    
    func body(content: Content) -> some View {
        content
            .fileExporter(isPresented: $showExportDialog, document: NoteDocument(note: note), contentType: UTType.rtf) { result in
                switch result {
                case .success(let success):
                    print("Sucess with \(success.absoluteString) ")
                case .failure(let failure):
                    print("Failure with \(failure.localizedDescription)")
                }
            }
            
    }
}

#Preview {
    NoteFileExporterButton(note: Note.example(),showExportDialog: .constant(false))
}
