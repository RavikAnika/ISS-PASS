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

class AuthenticationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    //This test verify that the delegate this correctly instantiated.
    func testDelegateAuthenticationController_WithAuthenticator_ShouldNotNil(){

        // variable that must be instantiated by the method Authenticator().
        let delegate: AuthenticatonControllerDelegate = Authenticator()

        //check if the variable delegate is not nil.
        XCTAssertNotNil(delegate,"The delegate of the authentication controller is Nil")

    }

    //This test verifies that we are getting the token after we make the Sign in app.
    func testGetToken_withAuthenticationControllerAuthorizationHeader_ShouldTokenNotNil(){

        #if swift(>=2.2)
            let expectation = self.expectationWithDescription("\(#function)")
        #else
            let expectation = self.expectationWithDescription("\(__FUNCTION__)")
        #endif

        

        //Variable of type Authenticator to access the methods of the class.
        let authentication: Authenticator = Authenticator()

        //Variable the Authentication Controller type that will be used as a parameter.
        let authenticationController: AuthenticationController = AuthenticationController()


        //Method to authenticate using login and password.
        authentication.authenticationController(authenticationController, authorizeWithUsername: "NameTest", password: "PasswordTest") { (ErrorType) -> Void in

            //Variable that should receive the token.
            let token = authentication.authenticationControllerAuthorizationHeader(authenticationController)

            //Check whether the Token not this nil.
            XCTAssertNotNil(token, "The Token is nil")
            expectation.fulfill()

        }

        self.waitForExpectationsWithTimeout(15.0) { (error) -> Void in
            XCTAssertNil(error, "\(error?.description)")
        }

    }

}
