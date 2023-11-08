//
//  ContentDetailNote.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI

struct ContentDetailNote: View {
    
    @ObservedObject var note: Note
    
    var body: some View {
        VStack (spacing: 20) {
            Text("order \(Int(note.order))")
            Text("Detail Note")
            
            HStack {
                Text ("Title: ")
                Text(note.title)
            }
            Picker(selection: $note.status) {
                ForEach(Status.allCases) {status in
                    Text(status.rawValue)
                        .tag(status)
                }
            } label: {
                Text("Note's status")
            }
            .pickerStyle(.segmented)
            
            
            TextField("New Note", text: $note.title)
            
            Button("clear note") {
                note.title = ""
            }.foregroundColor(.pink)
            
            Button("delete note") {
                let context = note.managedObjectContext
                context?.delete(note)
            }.foregroundColor(.red)
            
        }.padding()
            .onDisappear {
                PersistenceController.shared.save()
            }
    }
}


