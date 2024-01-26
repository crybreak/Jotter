//
//  ProfileSettingsView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 25/01/2024.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var birthday: Date = Date()
    @State private var favoriteColor = Color.accentColor
    @State private var isProUser = false

    
    var body: some View {
        Form{
            TextField("Enter your email adress", text: $email)
            TextField("Enter your password", text: $password)
            
            DatePicker("Enter your birhday", selection: $birthday.animation(), displayedComponents: [.date])
                .datePickerStyle(.stepperField)
            
            ColorPicker(selection: $favoriteColor.animation(), label: {
                Text("Color")
            })
            
            Divider()
            Text("Subscription")
            Toggle("Is a pro", isOn: $isProUser)
        }
        .padding()
    }
}

#Preview {
    ProfileSettingsView()
        .frame(width: 400, height: 400)
}
