//
//  NoteSearchViewModel.swift
//  Jotter
//
//  Created by macbook on 28/11/2023.
//

import Foundation
import Combine

class NoteSearchViewModel: ObservableObject {

    @Published private var selectedFolder: Folder? = nil
    
    @Published  var searchText: String = ""
    @Published  var searchTokens = [NoteSearchToken]()
    @Published  var searchScope = NoteSearchScope.selectedFolder
    
    //MARK: predicates
    
    @Published private var searchTextPredicate: NSPredicate? = nil
    @Published private var folderScopePredicate: NSPredicate? = nil
    @Published private var tokenPredicate: NSPredicate? = nil
    
    @Published var predicate: NSPredicate = .none

    var subscriptions = Set<AnyCancellable>()
    
    init () {
        $searchScope.sink{[unowned self] scope in
            self.folderScopePredicate = self.createScopePredicate(scope: scope,
                                                                folder: self.selectedFolder)
            self.createFullPredicate()
        }.store(in: &subscriptions)
        
        $searchText.sink {[unowned self] text in
            self.searchTextPredicate = createSearchTextPredicate(text: text)
            self.createFullPredicate()
        }.store(in: &subscriptions)
        
        $searchTokens.sink { [unowned self] tokens in
            self.tokenPredicate = createTokenPredicates(tokens: tokens)
            
            self.createFullPredicate()
        }
        .store(in: &subscriptions)
    }
    
    func folderChanged(to folder: Folder) {
        self.selectedFolder = folder
        self.searchScope = .selectedFolder
    }
    
    
    func addToken(_ token: NoteSearchToken) {
        guard searchTokens.contains(where: {$0 == token}) == false else {return}
        
        if token.isStatusToken() {
            for existingToken in searchTokens {
                 
                if existingToken.isStatusToken() {
                    guard let index = searchTokens.firstIndex(of: existingToken) else { return}
                    searchTokens.remove(at: index)
                }
            }
        }
        searchTokens.append(token)
    }
    
    func isTokenSelected(_ token: NoteSearchToken) -> Bool {
        
        searchTokens.firstIndex(of: token) != nil
    }
    
    func createFullPredicate() {
        var predicates = [NSPredicate]()
        
        if let searchTextPredicate = self.searchTextPredicate {
            predicates.append(searchTextPredicate)
        }
        
        if let folderScopePredicate = self.folderScopePredicate {
            predicates.append(folderScopePredicate)
        }
        
        
        if let tokenPredicate = self.tokenPredicate {
            predicates.append(tokenPredicate)
        }
        
        if predicates.count == 0 {
            self.predicate = NSPredicate.all
        } else if predicates.count == 1 {
            self.predicate = predicates.first ?? .none
        } else {
            self.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
    
    
    //MARK: -Create individuel pedicates
    private func createScopePredicate(scope: NoteSearchScope, folder: Folder?) -> NSPredicate? {
        
        if scope == .selectedFolder, let folder = folder {
            return NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
        } else {
            return nil
        }
    }
    
    private func createSearchTextPredicate(text: String) -> NSPredicate? {
        
        guard text.count > 0 else {return nil}
        
        let predicates = [NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, text as CVarArg),
                          NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.bodyText,
                                      text as CVarArg)]
        
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    
    private func createTokenPredicates(tokens: [NoteSearchToken]) -> NSPredicate? {
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
    
    
   private func createStatusPredicate(status: Status) -> NSPredicate {
        return NSPredicate(format: "%K == %@", NoteProperties.status, status.rawValue as CVarArg)
    }
    
    
    
    private func createLast7DaysPredicate() -> NSPredicate {
        let calendar = Calendar.current
        
        let beginDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        return NSPredicate(format: "%K > %@", NoteProperties.creationDate,
                                            beginDate as NSDate)
    }
    
    
    private func createLast24HoursPredicate() -> NSPredicate {
        let calendar = Calendar.current

        let beginDate = calendar.date(byAdding: .hour,  value: -24, to: Date())!
        return NSPredicate(format: "%K > %@", NoteProperties.creationDate,
                           beginDate as NSDate)
    }
    
    private func createAttachmentPredicate() -> NSPredicate {
        return NSPredicate(format: "%K != nil", NoteProperties.attachment)
    }
}
