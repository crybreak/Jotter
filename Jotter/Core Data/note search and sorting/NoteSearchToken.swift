//
//  NoteSearchToken.swift
//  Jotter
//
//  Created by macbook on 28/11/2023.
//

import Foundation

enum NoteSearchToken: CaseIterable, Identifiable {
    case draftStatus
    case reviewStatus
    case archivedStatus
    case last24Hours
    case last7Days
    case withAttachement
    
    
    var id: Self {self}
    var name: String {
        
        switch self {
        case .draftStatus:
            return "Draft"
        case .reviewStatus:
            return "Review"
        case .archivedStatus:
            return "Archived"
        case .last24Hours:
            return "24 Hours"
        case .last7Days:
            return "7 Days"
        case .withAttachement:
            return "Attachment"
        }
    }
    
    var fullName: String {
        
        switch self {
        case .draftStatus:
            return "Draft Status"
        case .reviewStatus:
            return "Review Status"
        case .archivedStatus:
            return "Archived Status"
        case .last24Hours:
            return "Last 24 Hours"
        case .last7Days:
            return "Last 7 Days"
        case .withAttachement:
            return "Notes with Attachment"
        }
    }
    
    func isStatusToken() -> Bool {
        switch self {
        case .archivedStatus, .reviewStatus, .draftStatus: return true
        case .last24Hours, .last7Days, .withAttachement: return false
        }
    }

}
