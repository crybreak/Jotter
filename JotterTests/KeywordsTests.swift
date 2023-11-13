//
//  KeywordsTests.swift
//  JotterTests
//
//  Created by macbook on 10/11/2023.
//

import XCTest
@testable import Jotter
import SwiftUI
import CoreData

final class KeywordsTests: XCTestCase {
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
    
  
    func test_Keywords_hex_Color() {
        let color =  Color(red: 0, green: 0, blue: 1);
        let keyword = Keyword(context: context)
        
        keyword.colorHex = color
        let retrievedColor = keyword.colorHex
        XCTAssertTrue(retrievedColor.toHex() == "0000FFFF")
        XCTAssertTrue(retrievedColor == color)

    }
    
    func test_Keyword_default_Color () {
        let color =  Color.black;
        let keyword = Keyword(context: context)
        let defaultColor =  keyword.color
        
        XCTAssertTrue(defaultColor == color)

    }

    func test_Keyword_component_Color () {
        let color = Color(red: 0, green: 0, blue: 1);
        let keyword = Keyword(context: context)
        keyword.color = color
        let retrievedColor = keyword.color
        
        XCTAssertTrue(retrievedColor == color, "No matching Color")

    }
}
