//
//  OnboardingView.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 27/01/2024.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage(wrappedValue: false, AppStorageKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool

    var body: some View {
        VStack  (spacing: 30){
            Text("Welcome Jotter")
                .font(.title)
            Image(systemName: "figure.fall")
            
            Button {
                hasSeenOnboarding = true
            } label: {
                Text("Done")
            }

        }.padding()
    }
}

#Preview {
    OnboardingView()
}
