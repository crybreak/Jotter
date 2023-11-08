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
            #if os(iOS)
            TextViewIOSWrapper(note: note)
            #else
            TextViewMacosWrapper(note: note)
            #endif
            
        }.padding()
            .onDisappear {
                PersistenceController.shared.save()
            }
    }
}


