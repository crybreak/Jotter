//
//  HelpCommads.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 27/01/2024.
//

import SwiftUI

struct HelpCommands: Commands {
    
    @Environment(\.openURL) var openUrl;
    
    var body: some  Commands {
        CommandGroup(after: .help) {
            Button(action: {
                if let url = URL(string: "https://www.apple.com") {
                    openUrl(url)
                }
            }, label: {
                Text("Contact Support")
            })
        }
    }
}
