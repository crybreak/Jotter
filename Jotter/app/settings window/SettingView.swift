//
//  SettingView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 25/01/2024.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        TabView {
            ProfileSettingsView()
                .tabItem {
                    Label( "Profile", systemImage: "person")
                }
            
            MenubarExtraSettingsView()
                .tabItem {
                    Label( "Menu bar", systemImage: "gear")
                }

        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
    }
}

#Preview {
    SettingView()
}
