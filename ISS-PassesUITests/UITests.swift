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

class UITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    //This test will run trough the User name and password box
    func testUserNameAndPasswordValids(){

        let app = XCUIApplication()

        //this line makes sure that the User name box is allways empty, so the code can run without bugs
        app.textFields["User name"].clearAndEnterText("")

        //we will write some names here
        let userNameTextField = app.textFields["User name"]
        userNameTextField.tap()
        userNameTextField.clearAndEnterText("testOne")
        userNameTextField.clearAndEnterText("testTwo")
        userNameTextField.clearAndEnterText("testThree")


        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.clearAndEnterText("passA")
        passwordSecureTextField.clearAndEnterText("passB")
        passwordSecureTextField.clearAndEnterText("passC")

        app.buttons["Sign In"].tap()


    }

    //No user name = must fail
    func testUserNameFieldWithoutText(){

        let app = XCUIApplication()

        let userNameTextField = app.textFields["User name"]
        userNameTextField.tap()
        userNameTextField.clearAndEnterText("testNOusername")

        //this line makes sure that the User name box is allways empty, so the code can run without bugs
        app.textFields["User name"].clearAndEnterText("")

        app.buttons["Sign In"].tap()
        app.alerts.collectionViews.buttons["OK"].tap()


    }

    //no password = must pass
    func testPasswordFieldWithoutText(){

        let app = XCUIApplication()

        //this line makes sure that the User name box is allways empty, so the code can run without bugs
        app.textFields["User name"].clearAndEnterText("")

        let userNameTextField = app.textFields["User name"]
        userNameTextField.tap()
        userNameTextField.clearAndEnterText("testNOpassword")

        //this line makes sure that the Password box is allways empty, so the code can run without bugs
        app.secureTextFields["Password"].clearAndEnterText("")


        app.buttons["Sign In"].tap()

    }

    //Testing how the App will behave with differente Device Orientations
    func testDeviceOrientation(){

        let device = XCUIDevice()

        device.orientation = .LandscapeLeft
        device.orientation = .Portrait
        device.orientation = .LandscapeRight
        device.orientation = .PortraitUpsideDown
        device.orientation = .LandscapeLeft
        device.orientation = .Portrait

        let app = XCUIApplication()

        //this line makes sure that the User name box is allways empty, so the code can run without bugs
        app.textFields["User name"].clearAndEnterText("")

        //we will write some names here
        let userNameTextField = app.textFields["User name"]
        userNameTextField.tap()
        userNameTextField.clearAndEnterText("testOne")


        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.clearAndEnterText("passA")

        app.buttons["Sign In"].tap()

        device.orientation = .LandscapeRight
        device.orientation = .PortraitUpsideDown
        device.orientation = .LandscapeLeft
        device.orientation = .Portrait
        device.orientation = .LandscapeRight
        device.orientation = .PortraitUpsideDown
    }

    func testSignOut(){

        let app = XCUIApplication()

        //this line makes sure that the User name box is allways empty, so the code can run without bugs
        app.textFields["User name"].clearAndEnterText("")

        //we will write some names here
        let userNameTextField = app.textFields["User name"]
        userNameTextField.tap()
        userNameTextField.clearAndEnterText("testOne")

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.clearAndEnterText("passA")

        let signInButton = app.buttons["Sign In"]
        signInButton.tap()

        let signOutButton = app.buttons["Sign Out"]
        signOutButton.tap()

        signInButton.tap()
        signOutButton.tap()

    }

    func testSampleRequest(){

        let app = XCUIApplication()

        //this line makes sure that the User name box is allways empty, so the code can run without bugs
        app.textFields["User name"].clearAndEnterText("")

        //we will write some names here
        let userNameTextField = app.textFields["User name"]
        userNameTextField.tap()
        userNameTextField.clearAndEnterText("testOne")

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.clearAndEnterText("passA")

        let signInButton = app.buttons["Sign In"]
        signInButton.tap()

        let sampleRequestButton = app.buttons["Sample Request"]
        sampleRequestButton.tap()

        let okButton = app.alerts["Result"].collectionViews.buttons["OK"]
        okButton.tap()
        sampleRequestButton.tap()
        okButton.tap()


    }

}

//This extension cleans the text fields
extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        var deleteString: String = ""
        for _ in stringValue.characters {
            deleteString += "\u{8}"
        }
        self.typeText(deleteString)

        self.typeText(text)
    }


}
