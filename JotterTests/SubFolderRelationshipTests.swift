//
//  SubFolderRelationshipTests.swift
//  JotterTests
//
//  Created by macbook on 14/11/2023.
//

import XCTest
import CoreData
@testable import Jotter

final class SubFolderRelationshipTests: XCTestCase {
    
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
    
    func test_add_subfolders_in_folder() {
        
        let folder = Folder(name: "Swift", context: context)
        let subFolder_1 = Folder(name: "Core Data", context: context)
        let subFolder_2 = Folder(name: "Combine", context: context)
        
        folder.children.insert(subFolder_1)
        folder.children.insert(subFolder_2)
        
        XCTAssertTrue(subFolder_1.parent == folder, "folder not contains subfolder ")
        XCTAssertTrue(folder.children.contains(subFolder_1), "folder not contains subfolder ")

    }
    
    func test_delete_subfolders_in_folders() {
        
        let folder = Folder(name: "Swift", context: context)
        let subFolder_1 = Folder(name: "Core Data", context: context)
        let subFolder_2 = Folder(name: "Combine", context: context)
        
        subFolder_1.parent = folder
        subFolder_2.parent = folder
        
        Folder.delete(subFolder_1)
        Folder.delete(subFolder_2)
        let retrivedFolder = try! context.fetch(Folder.fetch(NSPredicate.all))
        
        XCTAssertTrue(retrivedFolder.count == 1, "Folder contains subfolders")
        XCTAssertFalse(retrivedFolder.contains(subFolder_1), "Folder  contain subfolder_1")
    }
    
    func test_delete_subfolders_with_folder() {

        let folder = Folder(name: "Swift", context: context)
        let subFolder_1 = Folder(name: "Core Data", context: context)
        let subFolder_2 = Folder(name: "Combine", context: context)
        
        folder.children.insert(subFolder_1)
        folder.children.insert(subFolder_2)
        
        Folder.delete(folder)
        
        let retriedFolder = try? context.fetch(Folder.fetch(NSPredicate.all))
        
        XCTAssertNotNil(retriedFolder)
        XCTAssertTrue(retriedFolder?.count == 0, "parent folder could not be deleted")
    }
}
