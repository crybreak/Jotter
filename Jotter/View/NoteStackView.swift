//
//  NoteStackView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 05/02/2024.
//

import SwiftUI

struct NoteStackView: View {
    
    @EnvironmentObject var stateManager: NavigationStateManager
    
    #if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var isCompact: Bool {
        horizontalSizeClass == .compact
    }
    #else
    var isCompact = false
    #endif

  
    var body: some View {
        NavigationStack(path: $stateManager.path) {
            if let selectedNote = stateManager.selectedNote {
                ContentDetailNote(note: selectedNote)
                    .navigationDestination(for: Note.self) { note in
                        ContentDetailNote(note: note)
                    }
            } else {
                VStack {
                    if isCompact {
                        Image(systemName: "lasso.and.sparkles")
                            .imageScale(.large )
                    }
                    Text("select a note")
                        .foregroundStyle(.secondary)

                }
            }
        }
    }
}

#Preview {
    NoteStackView()
        .environmentObject(NavigationStateManager())
}
