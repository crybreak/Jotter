//
//  NoteDocument.swift
//  SlipboxProject
//
//  Created by Karin Prater on 09.02.23.
//

import SwiftUI
import UniformTypeIdentifiers

// use for fileExporter

class NoteDocument: ObservableObject, ReferenceFileDocument {
    
    enum SnapshotError: Error {
        case noNote
    }
    
    public typealias Snapshot = NSAttributedString
    
    @Published var note: Note?
    @Published var text: NSAttributedString
    
    init(note: Note) {
        self.note = note
        self.text =  note.nsAttributedStringExport()
    }
    
    public func fileWrapper(snapshot: NSAttributedString, configuration: WriteConfiguration) throws -> FileWrapper {
        let data = snapshot.toData()!
        return FileWrapper(regularFileWithContents: data)
    }

    public static var readableContentTypes: [UTType] {
        [.rtf]
    }
    
   
    required init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = data.toAttributedString()
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    
    public func snapshot(contentType: UTType) throws -> Snapshot {
        if let note = note {
            return note.nsAttributedStringExport()
        } else {
            throw SnapshotError.noNote
        }
    }
    
    func write(snapshot: NSAttributedString, to fileWrapper: inout FileWrapper, contentType: UTType) throws {
        let data = snapshot.toData()!
        fileWrapper = FileWrapper(regularFileWithContents: data)
    }
}
