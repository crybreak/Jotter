//
//  NavigationBackwardForwardButtonsView.swift
//  Jotter
//
//  Created by macbook on 11/12/2023.
//


import SwiftUI

struct NavigationBackwardForwardButtonsView: View {
    
    @Environment(\.undoManager) var undoManager
    @EnvironmentObject var stateManager: NavigationStateManager
    
    @State private var canUndo: Bool = false
    @State private var canRedo: Bool = false
    
    var body: some View {
        ControlGroup {
            
            Button {
                undoManager?.undo()
            }label: {
                Label("Go Backward", systemImage: "chevron.left")
            }.disabled(!canUndo)
            
            Button {
                undoManager?.redo()
            }label: {
                Label("Go Forward", systemImage: "chevron.right")
            }.disabled(!canRedo)
        }
        .onReceive(stateManager.objectWillChange.delay(for: 0.1, scheduler: RunLoop.main)) {
            _ in
            canUndo = undoManager?.canUndo ?? false
            canRedo = undoManager?.canRedo ?? false
        }
    }
}

#Preview {
    NavigationBackwardForwardButtonsView()
        .padding()
        .frame(width: 100, height: 100)
}
