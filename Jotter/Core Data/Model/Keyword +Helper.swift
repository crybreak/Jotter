//
//  KeywordClass +Helper.swift
//  Jotter
//
//  Created by macbook on 09/11/2023.
//

import SwiftUI

extension Keyword {
   
    var colorHex: Color {
        get {
            if let colorHexValue = self.colorHex_,
               let color = Color(hex: colorHexValue) {
                return color
            } else {
                return Color.black
            }
        } set {
            self.colorHex_ = newValue.toHex()
        }
    }
    
    var color: Color {
        get {
            Color(red: self.red_, green: self.green_, blue: self.blue_ )
            
        }
        set {
            guard let components = newValue.cgColor?.components,
                  components.count > 2 else {return}
            self.red_ = components[0]
            self.green_ = components[1]
            self.blue_ = components[2]
            
            if (components.count == 4) {
                self.opacity_ = components [3]
            } else {
                self.opacity_ = 1
            }
            

        }
    }
    
}
