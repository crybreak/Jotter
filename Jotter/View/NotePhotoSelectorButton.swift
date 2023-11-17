//
//  NotePhotoSelector.swift
//  Jotter
//
//  Created by macbook on 09/11/2023.
//

import SwiftUI
import PhotosUI

struct NotePhotoSelectorButton: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var note: Note;
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            note.attachment_ == nil ? Text("import photo") : Text("change photo")
        }
        .onChange(of: selectedItem) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    if let attachment = note.attachment_  {
                        attachment.fullImageData_ = data
                        attachment.thumbnailData = attachment.fullImageData_
                    } else {
                        note.attachment_ = Attachment(image: data, context: context)
                    }
                }
            }
        }
    }
}


struct NotePhotoSelector_Previews: PreviewProvider {
    static var previews: some View {
        NotePhotoSelectorButton(note: Note(title: "New Note",
                                     context: PersistenceController.shared.container.viewContext))
    }
}
