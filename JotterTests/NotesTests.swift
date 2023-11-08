//
//  NotesTests.swift
//  JotterTests
//
//  Created by macbook on 07/11/2023.
//

import XCTest
import CoreData
@testable import Jotter

final class NotesTests: XCTestCase {
    var controller: PersistenceController!
    
    var context: NSManagedObjectContext {
        controller.container.viewContext
    }
    
    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmptyStore()
    }
    
    override func tearDownWithError() throws {
        self.controller = nil
    }
    
    func test_Notes_Convenience_init() {
        let noteTitle = "New"
        let note = Note(title: noteTitle, context: context)
        
        XCTAssertTrue(note.title == noteTitle, "Note should have the title given in the convenience initializer")
    }
    
    func test_Notes_CreationDate() {
        let note = Note(context: context)
        let noteConvenient = Note(title: "New", context: context)
        
        XCTAssertNotNil(note.creationDate, "note should have creationDate property" )
        XCTAssertTrue(noteConvenient.creationDate != nil)
        XCTAssertFalse(noteConvenient.creationDate == nil)
    }
    
    func test_Notes_Updating_title() {
        let note = Note(title: "old", context: context)
        note.title = "new"
        
        XCTAssertTrue(note.title == "new")
    }
    
    func test_Fetch_All_Notes() {
        _ = Note(title: "default note", context: context)
        let fetch = Note.fetch(.all)
        let fetchedNotes = try? context.fetch(fetch)
        
        XCTAssertNotNil(fetchedNotes)
        XCTAssertTrue(fetchedNotes!.count > 0, "Predicate of none should not fetch at least one objects")
    }
    
    func test_Fetch_None_Notes () {
        _ = Note(title: "default note", context: context);
        let fetch = Note.fetch(.none)
        let fetchedNotes = try? context.fetch(fetch)
        
        XCTAssertNotNil(fetchedNotes)
        XCTAssertTrue(fetchedNotes!.count == 0, "Predicate of none should not fetch any objects")
    }
    
    func test_Delete_Note() {
        let note = Note(title: "default", context: context)
        
        Note.delete(note: note)
        let fecthedNotes = try? context.fetch(Note.fetch(.all))
        XCTAssertTrue(fecthedNotes!.count == 0, "deleted note should not be in database")
        XCTAssertFalse(fecthedNotes!.contains(note))
    }
    
    func test_Asynchronous_Save() {
        
        expectation(forNotification: .NSManagedObjectContextDidSave, object: context) {_ in
            return true
        }
        _ = Note(title: "default", context: context)
        controller.save()
        waitForExpectations(timeout: 1.0) {error in
            XCTAssertNil(error, "saving is not complete")
        }
    }
    
    func test_IsFavorite_Default_Value() {
        let note = Note(title: "default", context: context)
        
        XCTAssertFalse(note.isFavorite, "note is per default favorite")
    }
}
