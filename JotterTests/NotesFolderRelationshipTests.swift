//
//  NotesFolderRelationshpTests.swift
//  JotterTests
//
//  Created by macbook on 13/11/2023.
//

import XCTest
import CoreData
@testable import Jotter

final class NotesFolderRelationshpTests: XCTestCase {
    
    var controller: PersistenceController!
    
    var context: NSManagedObjectContext {
        self.controller.container.viewContext
    }
    override func setUpWithError() throws {
        self.controller = PersistenceController.createEmptyStore()
    }

    override func tearDownWithError() throws {
        self.controller = nil
    }
    
    func test_add_note_to_folder() {
        
        let note = Note(title: "New Note", context: context)
        let folder = Folder(name: "New Folder", context: context)
        
        folder.notes.insert(note)
        
        XCTAssertTrue(note.folder == folder)
        XCTAssertTrue(folder.notes.contains(note))
    }

    func test_delete_note_in_folder() {
        let note = Note(title: "New Note", context: context)
        let folder = Folder(name: "New Folder", context: context)
        
        folder.notes.insert(note)
        Note.delete(note: note)
        
        let retrievedNotes = try! context.fetch(Note.fetch(NSPredicate.all))
        XCTAssertTrue(retrievedNotes.count == 0)
        XCTAssertTrue(folder.notes.count == 0, "note isn't deleted")

    }
   
    func test_delete_folder_with_notes() {
        let note = Note(title: "New Note", context: context)
        let folder = Folder(name: "New Folder", context: context)
        
        note.folder = folder;
        Folder.delete(folder)
        
        let retrivedFolders = try! context.fetch(Folder.fetch(NSPredicate.all))
        let retrivedNotes = try! context.fetch(Note.fetch(NSPredicate.all))
        XCTAssertTrue(retrivedFolders.count == 0, "should have deleted the one folder")
        XCTAssertTrue(retrivedNotes.count == 0, "")
        
        
        
    }

}
