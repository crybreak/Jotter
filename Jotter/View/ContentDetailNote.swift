//
//  ContentDetailNote.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentDetailNote: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var note: Note
    @State private var showKeyword = false
    @State private var isTargeted = false
    
    var body: some View {
        VStack (alignment: .leading,spacing: 20) {
            HStack {
                if let folders = note.folder?.fullFolderPath() {
                    ForEach(folders) {folder in
                        HStack (spacing: 2) {
                            Image(systemName: "chevron.forward")
                            Image(systemName: "folder")
                            Text(folder.name)
                        }.onTapGesture {
                            withAnimation {
                                stateManager.folderChanged(to: folder)
                            }
                        }
                    }
                }
            }

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
            
            Group {
                if let attachment = note.attachment_ {
                    NoteAttachementView(attachment: attachment)
                } else {
                    ZStack {
                        Color.white
                        Image(systemName: "photo")
                            .imageScale(.large)
                            .foregroundStyle(.secondary)
                            
                    }
                    .frame(width: 100, height: 100)
                    .border(Color.gray)
                        
                   
                }
            }
            .overlay(isTargeted ? Color(white: 0.5, opacity: 0.5) :
                        Color.clear)
            .onDrop(of: [UTType.image, .jotterNote], isTargeted: $isTargeted,
                     perform: { providers in
                handleDrop(for: providers )
             })
            
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
    
    func handleDrop(for providers: [NSItemProvider]) -> Bool{
        
        var found = providers.loadFirstObject(ofType: UIImage.self) { image in
             #if os(OSX)
             guard let data = image.tiffRepresentation else {return}
             #else
             guard let data = image.pngData() else {return}
             #endif
             note.addImage(imageData: data)
         }
        if found == false {
            found = providers.loadFirstObject(ofType: NoteDragItem.self) {
                NoteDragItem in
                guard let id = NoteDragItem.id,
                      let droppedNote = Note.fetch(id, context: viewContext) else {
                          return
                      }
                
                guard note.uuid != droppedNote.uuid else {return}
                note.linkedNotes.insert(droppedNote)
            }
        }
         return found
    }
}


struct ContentDetailNote_Previews: PreviewProvider {
   static var previews: some View {
       ContentDetailNote(note: Note.example())
           .environment(\.managedObjectContext,
                         PersistenceController.preview.container.viewContext)
           .environmentObject(NavigationStateManager())
  }
}
