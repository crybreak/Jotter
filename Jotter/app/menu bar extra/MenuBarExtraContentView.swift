//
//  MenuBarExtraContentView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 26/01/2024.
//

import SwiftUI

struct MenuBarExtraContentView: View {
    var body: some View {
        VStack {
            Button ("open button 1") {
                
            }
            Button ("open button 2") {
                
            }
            Button ("open button 3") {
                
            }
            Divider()
            Button ("Quite") {
                NSApplication.shared.terminate(nil)
            }
        }
       
    }
}

#Preview {
    MenuBarExtraContentView()
}
