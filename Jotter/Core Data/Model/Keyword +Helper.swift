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
            Color(red: Double(self.red_), green: Double(self.green_), blue: Double(self.blue_) )
            
        }
        set {
            guard let components = newValue.cgColor?.components,
                  components.count > 2 else {return}
            self.red_ = Float(components[0])
            self.green_ = Float(components[1])
            self.blue_ = Float(components[2])
            
            if (components.count == 4) {
                self.opacity_ = Float(components [3])
            } else {
                self.opacity_ = 1
            }
            
        }
    }
    
    var notes: Set<Note> {
        get { (self.notes_ as? Set<Note>) ?? [] }
        set {self.notes_ = newValue as NSSet}
    }
    
}
