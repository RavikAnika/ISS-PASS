//
//  ISS_PassesTests.swift
//  ISS-PassesTests
//
//  Created by Ravi on 12/03/18.
//  Copyright © 2018 IBM. All rights reserved.
//

import XCTest

class ISS_PassesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPasses() {
        Pass.getAllPasses(Lat: 37.212, long: -67.788) { (Success, listofPasses, error) in
            print("The list of Passes", listofPasses, Success, error)
            XCTAssertNil(listofPasses , "list of Passes are nil")
            XCTAssertFalse(Success!, "No Passes")
            XCTAssertNotNil(error!, "Passes api service returned error")
       }
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
