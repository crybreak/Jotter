//
//  NoteSearchViewModel.swift
//  Jotter
//
//  Created by macbook on 28/11/2023.
//

import Foundation
import Combine
import CoreData

class NavigationStateManager: ObservableObject {
    
    @Published  var selectedNote: Note? = nil
    @Published  var selectedFolder: Folder? = nil
    
    @Published  var searchText: String = ""
    @Published  var searchTokens = [NoteSearchToken]()
    @Published  var searchScope = NoteSearchScope.selectedFolder
    
    //MARK: predicates
    
    @Published private var searchTextPredicate: NSPredicate? = nil
    @Published private var folderScopePredicate: NSPredicate? = nil
    @Published private var tokenPredicate: NSPredicate? = nil
    
    @Published var predicate: NSPredicate = .none
    
    @Published var noteHistory = [Note]()
    @Published private var totaltNotehistory = 5;

    let predicateHelper = NSpredicateHelper()

    var subscriptions = Set<AnyCancellable>()
    weak var undoManager: UndoManager?

    
    init () {
        $searchScope.sink{[unowned self] scope in
            self.folderScopePredicate = predicateHelper.createScopePredicate(scope: scope,
                                                                folder: self.selectedFolder)
            self.createFullPredicate()
        }.store(in: &subscriptions)
        
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink {[unowned self] text in
            self.searchTextPredicate = predicateHelper.createSearchTextPredicate(text: text)
            self.createFullPredicate()
        }.store(in: &subscriptions)
        
        $searchTokens.sink { [unowned self] tokens in
            self.tokenPredicate = predicateHelper.createTokenPredicates(tokens: tokens)
            
            self.createFullPredicate()
        }
        .store(in: &subscriptions)
        
        $selectedFolder.sink{[unowned self] folder in
            self.folderScopePredicate = predicateHelper.createScopePredicate(scope: searchScope , folder: folder)
            
            self.createFullPredicate()
        }.store(in: &subscriptions)
        
        $selectedNote.compactMap {$0}.sink {[unowned self] note in
            if self.noteHistory.contains(where: {$0 == note}) == false {
                if self.noteHistory.count < 5 {
                    self.noteHistory.append(note)
                } else {
                    totaltNotehistory = totaltNotehistory - 1
                    self.noteHistory.remove(at: totaltNotehistory)
                    self.noteHistory.append(note)
                    if totaltNotehistory  == 0 {
                        totaltNotehistory = 5
                    }
                }
            }
        }.store(in: &subscriptions)
    }
    
    func addNote() {
        
        guard let context = selectedFolder?.managedObjectContext else {return}
        
        let newNote  = Note(title: "New note1", context: context)
        newNote.folder = self.selectedFolder
        self.selectedNote = newNote
    }
    
    
    func folderChanged(to folder: Folder) {
        
        guard folder != self.selectedFolder  else {return}
        
        if let oldFolder = self.selectedFolder {
            undoManager?.registerUndo(withTarget: self, handler: { target in
                target.folderChanged(to: oldFolder)
            })
        }
        self.selectedFolder = folder
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
    
    //MARK: - State restoration
    
    func restoreState (noteID: String?, folderID: String?, context: NSManagedObjectContext) {
        if let uuidString = noteID, selectedNote == nil  {
            selectedNote = Note.fetch(uuidString, context: context)
        }
        
        if let uuidString = folderID, selectedFolder == nil  {
            selectedFolder = Folder.fetch(uuidString, context: context)
        }
    }
}
