//
//  NoteSorting.swift
//  Jotter
//
//  Created by macbook on 26/11/2023.
//

import Foundation

enum NoteSorting: Identifiable, CaseIterable{
    
    case titleAsc
    case titleDsc
    case creationDateAsc
    case creationDateDsc
    case status
    case day
    case letter
    
    
    var id: Self {self}
    
    func title() -> String {
        switch self {
        case .titleAsc:
            return "Title △"
        case .titleDsc:
            return "Title ▽"
        case .creationDateAsc:
            return "Date △"
        case .creationDateDsc:
            return "Date ▽"
        case .status:
            return "Status"
        case .day:
            return "Day"
        case .letter:
            return "Letter"
        }
    }
}
