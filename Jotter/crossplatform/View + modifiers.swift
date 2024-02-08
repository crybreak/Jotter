//
//  View + modifiers.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 05/02/2024.
//

import SwiftUI

extension View {
    func pidNavigationBarTitleDisplayMode() -> some View {
        #if os(iOS)
        self.navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
    func listStyleInsertAlternatingBackground() -> some View {
#if os(macOS)
        self.listStyle(.inset(alternatesRowBackgrounds: true))
#else
        self.listStyle(.inset)
#endif
    }

}

extension ToolbarItemPlacement {
    static var addItem: ToolbarItemPlacement {
#if os(iOS)
        .status
#else
        .primaryAction
#endif
    }
}
