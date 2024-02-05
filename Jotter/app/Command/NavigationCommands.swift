//
//  NavigationCommands.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 29/01/2024.
//

import SwiftUI

struct NavigationCommands: Commands {
    
    @FocusedValue(\.navigationForwardAction) var navigationForwardAction
    @FocusedValue(\.navigationBackwardAction) var navigationBackwardAction

    
    var body: some Commands {
        CommandMenu("Navigation") {
            Button {
                navigationForwardAction?()
            } label: {
                Label("Go Backward", systemImage: "chevron.backward")
            }.disabled(navigationForwardAction == nil)
                .keyboardShortcut(.leftArrow, modifiers: [.control,.command])
            
            Button {
                navigationBackwardAction?()
            } label: {
                Label("Go Forward", systemImage: "chevron.forward")
            }.disabled(navigationBackwardAction == nil)
                .keyboardShortcut(.rightArrow, modifiers: [.control,.command])



        }
    }
}

struct NavigationForwardKey: FocusedValueKey {
    typealias Value = () -> Void
}

struct NavigationBackwardKey: FocusedValueKey {
    typealias Value = () -> Void
}
extension FocusedValues {
    var navigationForwardAction : (() -> Void)? {
        get {self[NavigationForwardKey.self]}
        set {self[NavigationForwardKey.self] = newValue}
    }
    
    var navigationBackwardAction : (() -> Void)? {
        get {self[NavigationBackwardKey.self]}
        set {self[NavigationBackwardKey.self] = newValue}
    }
}

