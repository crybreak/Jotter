//
//  NoteRow.swift
//  Jotter
//
//  Created by macbook on 15/11/2023.
//

import SwiftUI

struct NoteRow: View {
    @EnvironmentObject var stateManager: NavigationStateManager
    @Environment(\.openWindow) var openWindow

    @ObservedObject var note: Note
    @State private  var showExportDialog = false

    
    var content: some View {
        VStack (alignment: .leading, spacing: 2){
            Text(note.title)
                .bold()
            
            HStack {
                Text(note.creationDate, formatter: itemFormatter)
                    .font(.caption)
                
                Text(note.status.rawValue)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 5,
                                                 style: .continuous).fill(Color.gray))
            }
            
            if note.bodyText.count > 0 {
                Text(note.bodyText)
                    .lineLimit(3)
            }
        }
    }
    
    var body: some View {
        content
        .tag(note)
        .onTapGesture {
            stateManager.noteChanged(to: note)
        }
        .onDrag {
            NSItemProvider(object: NoteDragItem(id: note.uuid))
        } preview: {
            content
                .foregroundStyle(Color.black)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(Color(.white)))
        }
#if os(OSX)

        .contextMenu {
            Button("Open in new window") {
                openWindow(id: WindowIdentifiers.noteScene, value: note.uuid)
            }
            
            Button("Delete") {
                Note.delete(note: note)
            }
        }
        #else
        .swipeActions (edge: .leading, allowsFullSwipe: false){
            Button (role: .destructive) {
                Note.delete(note: note)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            .labelStyle(.iconOnly)

            
            Button {
                
            } label: {
                Label("Move", systemImage: "folder")
            }
            .labelStyle(.iconOnly)
            .tint(.cyan)
            
            NoteFileExporterButton(note: note, showExportDialog: $showExportDialog)

            .tint(.indigo)
        }
        .modifier(NoteFileExportModifier(note: note, showExportDialog: $showExportDialog))
        
#endif

        
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
        NoteRow(note: Note.example())
            .padding()
            .frame(width: 300)
            .environmentObject(NavigationStateManager())
    }
}
