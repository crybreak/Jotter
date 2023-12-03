//
//  NoteSearchScope.swift
//  Jotter
//
//  Created by macbook on 28/11/2023.
//

import Foundation

enum NoteSearchScope: CaseIterable, Identifiable {
    case all
    case selectedFolder
    
    var id: Self {self}
    
    func name(folder: Folder?) -> String {
        switch self {
        case .all:
            return "All"
        case .selectedFolder:
            if let folder = folder {
                return " \'\(folder.name) \'"
            } else {
                return "This Folder"
            }
        }
    }
    
}
 
