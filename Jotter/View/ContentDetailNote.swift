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
    @State private  var showExportDialog = false
    @State  var image: Image? = nil
    
    var selectedNoteBinding: Binding<Note> {
        Binding {
            return note
        } set: { newNote in
            stateManager.selectedNote = note
        }
    }
    
    var body: some View {
      
        ScrollIOSContainer {
            VStack (alignment: .leading,spacing: 20) {
                ViewThatFits {
                    HStack {
                        NotePathFolderView(style: .hstack, note: note)
                            .fixedSize()
                        
                        HStack {
                            Spacer()
                            NoteStatusPickerView(note: note)
                                .labelsHidden()
                                .fixedSize()
                                .pickerStyle(.menu)
                        }
                    }
                    VStack (alignment: .leading) {
                        NotePathFolderView(style: .flowlayout, note: note)
                        
                        HStack {
                            Spacer()
                            NoteStatusPickerView(note: note)
                                .labelsHidden()
                                .fixedSize()
                                .pickerStyle(.menu)
                        }
                    }
                    
                }
                
                
    #if os(macOS)
                TextField("New Note", text: $note.title)
                    .textFieldStyle(.roundedBorder)
    #endif
                Group {
    #if os(iOS)
                    TextViewIOSWrapper(note: note)
                        .frame(minHeight: 300)
    #else
                    TextViewMacosWrapper(note: note)
    #endif
                }
                
                
                
                LinkedNotesView(note: note)
                NotesKeywordsCollectView(note: note)
                
                HStack {
                    VStack (spacing: 20) {
                        NotePhotoSelectorButton(note: note)
                        
                        if let image = image {
                            ShareLink(item: image, preview:
                                        SharePreview(note.title, image: image))
                        }
                        
                        Button(role: .destructive) {
                            Attachment.delete(note.attachment_)
                            image = nil
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    }
                    .labelStyle(.iconOnly)
                    .imageScale(.large)
                    .padding()
                    
                    Group {
                        if let attachment = note.attachment_ {
                            NoteAttachementView(attachment: attachment, thumbnailImage: $image)
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
                    .onDrop(of: [UTType.image], isTargeted: $isTargeted,
                            perform: { providers in
                        handleDrop(for: providers )
                    })
    #if os(OSX)
                    .importsItemProviders(Note.importImageTypes) { providers in
                        handleDrop(for: providers)
                    }
    #endif
                }
                .padding()
                
                .onDisappear {
                    PersistenceController.shared.save()
                }
                .navigationTitle($note.title)
                #if os(iOS)
                .pidNavigationBarTitleDisplayMode()
                #endif
                .toolbarRole(.editor)
                .toolbarTitleMenu(content: {
                    RenameButton()
                
                    CopyNoteButton(note: note)
                    
                    Button {
                    } label: {
                        Label("Duplicate", systemImage: "plus.square.on.square")
                    }
                    
                   
                    NoteFileExporterButton(note: note, showExportDialog: $showExportDialog)


                    Divider()
                    Button(role: .destructive) {
                        Note.delete(note: note)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                })
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction){
                        Button {
                            showKeyword.toggle()
                        } label: {
                            Image(systemName: "tag")
                        }.popover(isPresented: $showKeyword) {
                            AddKeywordsToNoteView(note: note)
                                .environment(\.managedObjectContext, viewContext)
                        }
                        #if os(iOS)
                        EditlinkedNoteView(note: note)

                        NoteShareButtons(note: note)
                        #else
                        NoteFileExporterButton(note: note, showExportDialog: $showExportDialog)
                        CopyNoteButton(note: note)
                        
                        #endif

                    }
                }
                .modifier(NoteFileExportModifier(note: note, showExportDialog: $showExportDialog))
            .focusedSceneValue(\.selectedNote, selectedNoteBinding)
            }
        }
    }
    
    func handleDrop(for providers: [NSItemProvider]) -> Bool{
        
        let found = providers.loadFirstObject(ofType: UIImage.self) { image in
             #if os(OSX)
             guard let data = image.tiffRepresentation else {return}
             #else
             guard let data = image.pngData() else {return}
             #endif
             note.addImage(imageData: data)
         }
         return found
    }
}


struct ContentDetailNote_Previews: PreviewProvider {
   static var previews: some View {
       return NavigationView {
           Group {
               ContentDetailNote(note: Note.example())
//               ContentDetailNote(note: Note.exampleLongFolder())
           }
               .environment(\.managedObjectContext,
                             PersistenceController.preview.container.viewContext)
               .environmentObject(NavigationStateManager())
               .environmentObject(LinkedNoteClipboard())
       }
         
  }
}
