//
//  NoteSearchViewModel.swift
//  Jotter
//
//  Created by macbook on 28/11/2023.
//

import Foundation

class NoteSearchViewModel: ObservableObject {

    @Published  var searchText: String = ""
    @Published  var searchTokens = [NoteSearchToken]()
    @Published  var searchScope = NoteSearchScope.selectedFolder

    @Published var predicate: NSPredicate = .none

    func addToken(_ token: NoteSearchToken) {
        searchTokens.append(token)
    }
    
    func isTokenSelected(_ token: NoteSearchToken) -> Bool {
        
        searchTokens.firstIndex(of: token) != nil
    }
    
    //MARK: -Create individuel pedicates
    
     func createSearchTextPredicat(text: String) -> NSPredicate? {
        
        guard text.count > 0 else {return nil}
        
        let predicates = [NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.bodyText,
                                      text as CVarArg)]
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    func createScopePredicate(scope: NoteSearchScope, folder: Folder?) -> NSPredicate? {
        
        if scope == .selectedFolder, let folder = folder {
            return NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
            
        }
        return nil
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
                <#code#>
            case .last7Days:
                <#code#>
            case .withAttachement:
                <#code#>
            }
        }
    }
    
    func createStatusPredicate(status: Status) -> NSPredicate {
        return NSPredicate(format: "%K == %@", NoteProperties.status, status.rawValue as CVarArg)
    }
}
