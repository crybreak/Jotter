//
//  Scene + modifiers.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 05/02/2024.
//

import SwiftUI

extension Scene {
    func piDefaultPosition(_ position: UnitPoint) -> some Scene {
        #if os(OSX)
        return self.defaultPosition(position)
        #else
        return self
        #endif
    }
    
    func pidDefaultSize (width: CGFloat, height: CGFloat) -> some Scene {
        #if os(OSX)
        return self.defaultSize(width: width, height: height)
        #else
        self
        #endif
    }
    
    
    func pidWindowToolbarStyle() -> some Scene  {
        #if os(OSX)
        return self.windowToolbarStyle(.unified(showsTitle: true))
        #else
        return self
        #endif
        
    }
  
}
