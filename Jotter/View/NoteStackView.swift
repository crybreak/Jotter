//
//  NoteStackView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 05/02/2024.
//

import SwiftUI

struct NoteStackView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
  
    var body: some View {
        NavigationStack(path: $stateManager.path) {
            if let selectedNote = stateManager.selectedNote {
                ContentDetailNote(note: selectedNote)
                    .navigationDestination(for: Note.self) { note in
                        ContentDetailNote(note: note)
                    }
            } else {
                Text("")
            }
        }
    }
}

#Preview {
    NoteStackView()
        .environmentObject(NavigationStateManager())
}
