//
//  ContentDetailNote.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI

struct ContentDetailNote: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var note: Note
    @State private var showKeyword = false
    var body: some View {
        VStack (spacing: 20) {
            Text("order \(Int(note.order))")
            Text("canonical: \(note.canonicalTitle_ ?? "")")
            
            TextField("New Note", text: $note.title)
            
            Picker(selection: $note.status) {
                ForEach(Status.allCases) {status in
                    Text(status.rawValue)
                        .tag(status)
                }
            } label: {
                Text("Note's status")
            }
            .pickerStyle(.segmented)
                        
            HStack {
#if os(iOS)
TextViewIOSWrapper(note: note)
#else
TextViewMacosWrapper(note: note)
#endif
            }
            
            if let attachment = note.attachment_ {
                NoteAttachementView(attachment: attachment)
            }
        NotePhotoSelectorButton(note: note)
            
        NotesKeywordsCollectView(note: note)
        }
        .padding()
        .onDisappear {
            PersistenceController.shared.save()
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showKeyword.toggle()
                } label: {
                    Image(systemName: "tag")
                }.popover(isPresented: $showKeyword) {
                    AddKeywordsToNoteView(note: note)
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }
}


struct ContentDetailNote_Previews: PreviewProvider {
   static var previews: some View {
       ContentDetailNote(note: Note.example())
           .environment(\.managedObjectContext,
                         PersistenceController.preview.container.viewContext)
  }
}
