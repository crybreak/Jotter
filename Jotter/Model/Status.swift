//
//  Status.swift
//  Jotter
//
//  Created by macbook on 08/11/2023.
//

import Foundation

enum Status: String, Identifiable, CaseIterable{
    
    case draft = "Draft"
    case review = "Review"
    case archieve = "Archieve"
    
    var id: String {
        return self.rawValue
    }
}
