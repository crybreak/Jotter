//
//  Predicate + Helper.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import Foundation
import CoreData

extension NSPredicate {
    
    static let all = NSPredicate(format: "TRUEPREDICATE")
    static let none = NSPredicate(format: "FALSEPREDICATE")
}
