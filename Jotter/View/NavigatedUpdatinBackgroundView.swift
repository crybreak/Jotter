//
//  NavigatedUpdatinBackgroundView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 29/01/2024.
//

import SwiftUI

struct NavigatedUpdatinBackgroundView: View {
    @EnvironmentObject var stateManager: NavigationStateManager
    @Environment(\.undoManager) var undoManager
    
    
    @State private var canUndo: Bool = false
    @State private var canRedo: Bool = false
    
    var body: some View {
        Group {
            if canUndo {
                Text("Can undo")
                    .focusedSceneValue(\.navigationBackwardAction, undoManager?.undo)
            }
            if canRedo {
                Text("Can redo")
                    .focusedSceneValue(\.navigationForwardAction, undoManager?.redo)
            }
        
        }
        .foregroundColor(.clear)
        .onReceive(stateManager.objectWillChange.delay(for: 0.1, scheduler: RunLoop.main)) {
            _ in
            canUndo = undoManager?.canUndo ?? false
            canRedo = undoManager?.canRedo ?? false
        }
    }
}

#Preview {
    NavigatedUpdatinBackgroundView()
}
