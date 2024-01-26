//
//  MenubarExtraSettingsView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 25/01/2024.
//

import SwiftUI

struct MenubarExtraSettingsView: View {
    @AppStorage(wrappedValue: false, AppStorageKeys.showMenuBarExtra)var showMenuBar: Bool
    var body: some View {
        Form {
            Toggle("show menu bar extra", isOn: $showMenuBar)
        }
    }
}

#Preview {
    MenubarExtraSettingsView()
}
