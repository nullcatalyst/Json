//
//  JsonTests.swift
//  JsonTests
//
//  Created by Scott Bennett on 2014-08-03.
//  Copyright (c) 2014 Scott Bennett. All rights reserved.
//

import Cocoa
import XCTest
import Json

class JsonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testString() {
        var string: Json = "test\nString"
        
        // Verify that the parser is escaping characters correctly
        if let parse = Json.parse("\"test\\nString\"") {
            XCTAssertEqual(parse, string, "The entry with key \"boolean\" should have been removed")
        } else {
            XCTFail("Should be able to parse the json string type successfully")
        }
    }
    
    func testArrayAccess() {
        var array: Json = [0, 1, 2]
        
        // Check array elements
        XCTAssert(array[0]? == 0, "Element 0 should equal 0")
        XCTAssert(array[1]? == 1, "Element 1 should equal 1")
        XCTAssert(array[2]? == 2, "Element 2 should equal 2")
        
        // Remove from the array
        array[1] = nil
        XCTAssert(array[1]? == 2, "Element 1 should equal 2")
        
        // Key access to an array
        XCTAssert(array["test"]? == nil, "Should not be able to use a key to access an array")
    }
    
    func testObjectAccess() {
        var object: Json = ["boolean": true, "number": 4]
        
        XCTAssertEqual(object, ["boolean": true, "number": 4], "Assert that the object literal conversion worked properly")
        object["boolean"] = nil
        XCTAssertEqual(object, ["number": 4], "The entry with key \"boolean\" should have been removed")
    }
    
    func testParser() {
        if let object = Json.parse("{\"answer\": 42, \"question\": \"6 * 9\"}") {
            XCTAssertEqual(object, ["answer": 42, "question": "6 * 9"], "Assert that the object was parsed correctly")
        } else {
            XCTFail("{\"answer\": 42} should have been parsed as a valid object")
        }
        
        if let object = Json.parse("{answer: 42, question: \"6 * 9\"}") {
            XCTAssertEqual(object, ["answer": 42, "question": "6 * 9"], "Assert that the object was parsed correctly")
        } else {
            XCTFail("{\"answer\": 42} should have been parsed as a valid object")
        }
    }
}
