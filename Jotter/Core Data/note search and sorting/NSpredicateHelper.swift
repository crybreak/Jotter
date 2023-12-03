//
//  NSpredicateHelper.swift
//  Jotter
//
//  Created by macbook on 30/11/2023.
//

import Foundation
import CoreData

class NSpredicateHelper {
    
    func createScopePredicate(scope: NoteSearchScope, folder: Folder?) -> NSPredicate? {
        
        if scope == .selectedFolder, let folder = folder {
            return NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
        } else {
            print("no note selected")
            return nil
        }
    }
    
     func createSearchTextPredicate(text: String) -> NSPredicate? {
        
        guard text.count > 0 else {return nil}
        
        let predicates = [NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.bodyText,
                                      text as CVarArg)]
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    
     func createTokenPredicates(tokens: [NoteSearchToken]) -> NSPredicate? {
        var predicates = [NSPredicate]()
        
        for token in tokens {
            switch token {
            case .draftStatus:
                predicates.append(createStatusPredicate(status: Status.draft))
            case .reviewStatus:
                predicates.append(createStatusPredicate(status: Status.review))
            case .archivedStatus:
                predicates.append(createStatusPredicate(status: Status.archieve))
            case .last24Hours:
                predicates.append(createLast24HoursPredicate())
            case .last7Days:
                predicates.append( createLast7DaysPredicate())
            case .withAttachement:
                predicates.append( createLast7DaysPredicate())
            }
        }
        if predicates.count == 0 {
            return nil
        } else if predicates.count == 1 {
            return predicates.first
        } else {
            return NSCompoundPredicate(orPredicateWithSubpredicates: predicates )
        }
    }
    
    
    func createStatusPredicate(status: Status) -> NSPredicate {
        return NSPredicate(format: "%K == %@", NoteProperties.status, status.rawValue as CVarArg)
    }
    
    
    
    private func createLast7DaysPredicate() -> NSPredicate {
        let calendar = Calendar.current
        
        let beginDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        return NSPredicate(format: "%K > %@", NoteProperties.creationDate,
                                            beginDate as NSDate)
    }
    
    
     func createLast24HoursPredicate() -> NSPredicate {
        let calendar = Calendar.current

        let beginDate = calendar.date(byAdding: .hour,  value: -24, to: Date())!
        return NSPredicate(format: "%K > %@", NoteProperties.creationDate,
                           beginDate as NSDate)
    }
    
    func createAttachmentPredicate() -> NSPredicate {
        return NSPredicate(format: "%K != nil", NoteProperties.attachment)
    }
}
