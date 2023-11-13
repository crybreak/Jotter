//
//  FoldersTests.swift
//  JotterTests
//
//  Created by macbook on 10/11/2023.
//

import XCTest
import CoreData
@testable import Jotter

final class FoldersTests: XCTestCase {
    
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

    func test_Folder_Convenience_init () {
        let folder = Folder(name: "equity", context: context)
        
        XCTAssertTrue(folder.name == "equity")
        
    }
    
    func test_Foder_Updating_Name() {
        let folder = Folder(name: "equity", context: context)
        folder.name = "emptyFolder"
        
        XCTAssertTrue(folder.name == "emptyFolder")
    }
    
    func test_Folder_creationDate() {
        let folder = Folder(name: "equity", context: context)
        
        XCTAssertNotNil(folder.creationDate, "folder should have creation date")

    }
    
    func test_Fetch_All_Notes() {
        let folder1 = Folder(name: "first", context: context)
        let folder2 = Folder(name: "second", context: context)
        
        let request = Folder.fetch(.all)
        let retrivedFolders = try? context.fetch(request)
        
        XCTAssertNotNil(retrivedFolders)
        XCTAssertTrue(retrivedFolders?.count == 2, "should retrive 2 folders that where added to database")
        
        XCTAssertTrue(retrivedFolders!.contains(folder1))
        XCTAssertTrue(retrivedFolders!.contains(folder2))
        
        XCTAssertTrue(retrivedFolders?.first == folder1)
        XCTAssertTrue(retrivedFolders?.last == folder2)
    }
    
    func test_Folder_delete() {
        let folder = Folder(name: "equity", context: context)
        
        Folder.delete(folder)
        let retrivedFolders = try? context.fetch(Folder.fetch(.all))
        XCTAssertTrue(retrivedFolders?.count == 0)
    }
    
    
    

}
