//
//  NoteFetchTest.swift
//  JotterTests
//
//  Created by macbook on 19/11/2023.
//

import XCTest
import CoreData
@testable import Jotter

final class NoteFetchTest: XCTestCase {
    var controller: PersistenceController!
    var context: NSManagedObjectContext {
        controller.container.viewContext
    }
    
    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmptyStore()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        self.controller = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    //MARK: - c: Sensitive cd: for ignore dieleitric
    func test_search_term_notes() {
        let note1 = Note(title: "Täst", context: context)
        let note2 = Note(title: "Dummy", context: context)
        
        let searchTerm = "tast"
        
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, searchTerm as CVarArg)
        let request = Note.fetch(predicate)
        
        
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertFalse(retrievedNotes.contains(note2))
    }
    
    func test_search_term_in_title_or_bodytext() {
        let note1 = Note(title: "Dummy", context: context)
        note1.formattedBodyText = NSAttributedString(string: "test")
        let note2 = Note(title: "test more", context: context)
        
        let searchTerm = "test"
        let predicate = NSpredicateHelper().createSearchTextPredicate(text: searchTerm)
        
        let request = Note.fetch(predicate!)
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 2)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertTrue(retrievedNotes.contains(note2))
    }
    
    func test_search_multi_ter_notes() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        
        let searchTerms = ["Hello", "World"]
        
        var predicates = [NSPredicate]()
        
        for term in searchTerms {
            predicates.append(NSPredicate(format: "%K CONTAINS[cd] %@", NoteProperties.title, term as CVarArg))
        }
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 2)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertTrue(retrievedNotes.contains(note2))
    }
    
    func test_filter_by_notes_status_default_draft() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        let note3 = Note(title: "note 3", context: context)
        
        let filterStatus = Status.draft
        
        let predicate = NSPredicate(format: "%K == %@" , NoteProperties.status,filterStatus.rawValue as CVarArg)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 3)
        XCTAssertTrue(retrievedNotes.contains(note3))
        XCTAssertTrue (retrievedNotes.contains(note2))
        
    }
    
    func test_filter_by_notes_status_archieve() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        let note3 = Note(title: "note 3", context: context)
        
        note3.status = .archieve
        let filterStatus = Status.archieve
        
        let predicate = NSPredicate(format: "%K == %@" , NoteProperties.status,filterStatus.rawValue as CVarArg)
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertTrue(retrievedNotes.contains(note3))
        XCTAssertFalse (retrievedNotes.contains(note2))
        
    }
    
    func test_search_favorite_notes() {
        let note1 = Note(title: "Hello and World", context: context)
        let note2 = Note(title: "test more world", context: context)
        
        note1.isFavorite = true
        note2.isFavorite = true
        
        let predicate = NSPredicate(format: "isFavorite == true" )
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 2)
        XCTAssertTrue(retrievedNotes.contains(note1))
        XCTAssertTrue (retrievedNotes.contains(note2))
        
    }
    
    func test_fetch_notes_for_last_7_days() {
        
        let calendar = Calendar.current
   
        let beginDate = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        let note1 = Note(title: "Hello and World", context: context)
        note1.creationDate_ = calendar.date(byAdding: .day, value: 2, to: Date())!
       

        let note2 = Note(title: "test more world", context: context)
        note2.creationDate_ = calendar.date(byAdding: .day, value: -9, to: Date())!
        print( note2.creationDate_! )

        
        let predicate = NSPredicate(format: "%K < %@", NoteProperties.creationDate,
                                    beginDate as NSDate)
        
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrievedNotes.count == 1)
        XCTAssertFalse(retrievedNotes.contains(note1))
        XCTAssertTrue (retrievedNotes.contains(note2))
    }
    
    func test_fetch_notes_of_last_week() {
        let calendar = Calendar.current
        let today = Date()
        
        //        print("today \(today.description(with: .current))")
        let endDATE = calendar.date(byAdding: .day, value: 1, to: today)
        for index in 0..<8 {
            let note = Note(title: "", context: context)
            note.creationDate_ = calendar.date(byAdding: .day, value: -index, to: today)
            //        ? print("note day \(note.creationDate.description(with: .current))")
        }
        let startOfWeek = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear],
                                                  from: today).date!
        //        print("startOfWeek \(startOfWeek.description(with: .current))")
        
        let startOflastWeek = calendar.date(byAdding: .day, value: -7, to: today)
        
        let predicate = NSPredicate(format: "creationDate_ > %@ AND creationDate_ <= %@", argumentArray: [startOflastWeek!, startOfWeek] )
        
        let request = Note.fetch(predicate)
        let retrievedNotes = try! context.fetch(request)
        XCTAssertTrue(retrievedNotes.count == 5)
    }
    
    //MARK: fetching  in relationship
    func test_search_notes_for_folder() {
        
        let note1 = Note(title: "note", context: context)
        let folder = Folder(name: "folder", context: context)
        folder.notes.insert(note1)
        
        let predicate = NSPredicate(format: "%K == %@", NoteProperties.folder, folder)
        let request = Note.fetch(predicate)
        
        let retrivedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrivedNotes.count == 1)
        XCTAssertTrue(retrivedNotes.contains(note1))
    }
    
    func test_search_with_keywords() {
        
        let keyword = Keyword(context: context)
        let note1 = Note(title: "dd", context: context)
        note1.keywords.insert(keyword)
        
        let note2 = Note(title: "note 2", context: context)
        let note3 = Note(title: "note 3", context: context)
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", NoteProperties.keywords, keyword)
        let request = Note.fetch(predicate)
        let retrivedKeywords = try! context.fetch(request)
        
        XCTAssertTrue(retrivedKeywords.count == 1)
        XCTAssertTrue(retrivedKeywords.contains(note1))
    }
    
    func test_search_notes_for_multiple_keywords() {
        let keyword1 = Keyword(context: context)
        let keyword2 = Keyword(context: context)

        let note1 = Note(title: "dd", context: context)
        note1.keywords.insert(keyword1)
        
        let note2 = Note(title: "note 2", context: context)
        let note3 = Note(title: "note 3", context: context)
        keyword2.notes.insert(note3)
        
        var selectKeywors = Set<Keyword>()
        selectKeywors.insert(keyword1)
        selectKeywors.insert(keyword2)
        
        let predicate = NSPredicate(format: "ANY %K in %@" , NoteProperties.keywords, selectKeywors)
        let request = Note.fetch(predicate)
        let retrivedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrivedNotes.count == 2)
        XCTAssertTrue(retrivedNotes.contains(note1))
        XCTAssertTrue(retrivedNotes.contains(note3))
    }

    func test_search_notes_without_selected_keywords() {
        let keyword1 = Keyword(context: context)
        let keyword2 = Keyword(context: context)

        let note1 = Note(title: "dd", context: context)
        note1.keywords.insert(keyword1)
        
        let note2 = Note(title: "note 2", context: context)
        let note3 = Note(title: "note 3", context: context)
        keyword2.notes.insert(note3)
        
        var selectKeywords = Set<Keyword>()
        selectKeywords.insert(keyword1)
        selectKeywords.insert(keyword2)
        
        let predicate = NSPredicate(format: "NONE %K in %@" , NoteProperties.keywords, selectKeywords)
        let request = Note.fetch(predicate)
        let retrivedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrivedNotes.count == 1)
        XCTAssertTrue(retrivedNotes.contains(note2))
    }
    
    func test_search_notes_with_no_keywords() {
        let keyword1 = Keyword(context: context)
        let keyword2 = Keyword(context: context)

        let note1 = Note(title: "dd", context: context)
        note1.keywords.insert(keyword1)
        
        let note2 = Note(title: "note 2", context: context)
        let note3 = Note(title: "note 3", context: context)
        keyword2.notes.insert(note3)
        note1.keywords.insert(keyword2)
        
        
        let predicate = NSPredicate(format: "%K.@count == 2", NoteProperties.keywords)
        let request = Note.fetch(predicate)
        let retrivedNotes = try! context.fetch(request)
        
        XCTAssertTrue(retrivedNotes.count == 1)
        XCTAssertTrue(retrivedNotes.contains(note1))
        XCTAssert(note3.keywords.contains(keyword2))
    }

}
