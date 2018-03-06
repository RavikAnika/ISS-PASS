/*
 * Assembly Kit
 * Licensed Materials - Property of IBM
 * Copyright (C) 2015 IBM Corp. All Rights Reserved.
 * 6949 - XXX
 *
 * IMPORTANT:  This IBM software is supplied to you by IBM
 * Corp. ("IBM") in consideration of your agreement to the following
 * terms, and your use, installation, modification or redistribution of
 * this IBM software constitutes acceptance of these terms. If you do
 * not agree with these terms, please do not use, install, modify or
 * redistribute this IBM software.
 */

import XCTest
@testable import ISS-Passes

class NetworkingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        //Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        //Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    //this test is designed to verify app behavior when requeste response returns a status code 200.
    func testRequestModule_WithSampleParametersExecutionAndValidate_ShouldResultStatusCode200() {

        #if swift(>=2.2)
            let expectation = self.expectationWithDescription("\(#function)")
        #else
            let expectation = self.expectationWithDescription("\(__FUNCTION__)")
        #endif
        
      
        Request.Sample.execute().validate().responseString { (urlRequest, urlResponse, string, error) -> Void in

            //variable that will be used to compare the response status code.
            let StatusCode = 200

            //check the response status code is not nil.
            XCTAssertNotNil(urlResponse?.statusCode, "The StatusCode is Nil")

            //check if the variable StatusCode is equal to the status code of the response
            XCTAssertEqual(StatusCode, urlResponse?.statusCode, "the StatusCode \(urlResponse?.statusCode) not success ")

            expectation.fulfill()


        }
        self.waitForExpectationsWithTimeout(15.0) { (error) -> Void in
            XCTAssertNil(error, "\(error?.description)")
        }
    }

}
