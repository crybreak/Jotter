//
//  ColorsTests.swift
//  JotterTests
//
//  Created by macbook on 10/11/2023.
//

import XCTest
@testable import Jotter
import SwiftUI
final class ColorsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Hex_Color() {
        
        let colorBlue = Color(hex: "0000FF")
        let colorBlueApla = Color(hex: "0000FFFF")
        let referenceColorBlue = Color(red: 0, green: 0, blue: 1)
        
        XCTAssertTrue(colorBlue == referenceColorBlue, "No correspondance")
        XCTAssertTrue(colorBlueApla == referenceColorBlue, "No correspondance")

    }
    
    func test_Color_to_Hex() {
        let referenceColorBlue = Color(red: 0, green: 0, blue: 1)
        let hex = referenceColorBlue.toHex()
        
        XCTAssertTrue(hex == "0000FFFF", "No correspondance")
    }
    

}
