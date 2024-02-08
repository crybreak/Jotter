//
//  ScrollIOSContainer.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 05/02/2024.
//

import SwiftUI

struct ScrollIOSContainer <Content>: View where Content: View {
    
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        #if os(iOS)
        ScrollView(content: content)
        #else
        content()
        #endif
    }
}
//
////#Preview {
////    ScrollIOSContainer()
//}
