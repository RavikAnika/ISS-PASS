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

import Foundation
import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

let kFrameworkBundle = Bundle(for: BaseLoginViewController.self)

let kAlertLoginUsernamePasswordErrorMSG = NSLocalizedString(
    "Make sure you have entered a user name and password", bundle: kFrameworkBundle,
    comment: "Make sure you have entered a user name and password")
let kAlertLoginUsernameErrorMSG = NSLocalizedString("Make sure you have entered a user name",
    bundle: kFrameworkBundle, comment: "Make sure you have entered a user name")
let kAlertLoginFunctionNotImplementedMSG = NSLocalizedString(
    "Sorry, this functionality has not been implemented", bundle: kFrameworkBundle,
    comment: "Sorry, this functionality has not been implemented")
let kAlertLogoutConfirmMSG = NSLocalizedString("Are you sure you want to log out?",
    bundle: kFrameworkBundle, comment: "Are you sure you want to log out?")
let kAlertButtonOK = NSLocalizedString("OK", bundle: kFrameworkBundle, comment: "OK")
let kAlertButtonCancel = NSLocalizedString("Cancel", bundle: kFrameworkBundle, comment: "Cancel")

let kAlertTouchIDReasonString = NSLocalizedString("Scan fingerprint to log in", bundle:kFrameworkBundle,
    comment: "Scan fingerprint to log in")
let kAlertTouchIDFallbackTitle = NSLocalizedString("Enter Username and Password", bundle:kFrameworkBundle,
    comment: "Enter Username and Password")
let kAlertTouchIDUnsuccessful = NSLocalizedString("Unsuccessful", bundle:kFrameworkBundle,
    comment: "Unsuccessful")
let kAlertTouchIDAuthenticationFailed = NSLocalizedString("Authentication Failed", bundle:kFrameworkBundle,
    comment: "Authentication Failed")
let kAlertTouchIDCancelled = NSLocalizedString("System Cancelled", bundle:kFrameworkBundle,
    comment: "System Cancelled")
let kAlertTouchIDUnableAuthenticate = NSLocalizedString("Unable to Authenticate", bundle:kFrameworkBundle,
    comment: "Unable to Authenticate")
let kAlertTouchIDNotAvailable = NSLocalizedString("Touch ID is not available", bundle:kFrameworkBundle,
    comment: "Touch ID is not available")
let kAlertTouchIDNotEnrolled = NSLocalizedString("Touch ID is not enrolled", bundle:kFrameworkBundle,
    comment: "Touch ID is not enrolled")

//**********************************************************************************************************
//
// MARK: - Constants -
//
//****************************** ****************************************************************************

let keychainErrorDomain = "com.ibm.mobilefirst.frameworks.MFKeychain"
let defaultKeychainService = bundleIdentifier() //Workaround for Apple bug. See bundleIdentifier description.
let defaultSecurityClass = SecurityClass.genericPassword

/**
 This method was create because exist a bug when we access kCFBundleIdentifierKey and Apple show this message
 on Xcode console:
 *** Test operation was canceled. If you believe this error represents a bug.
 */
func bundleIdentifier() -> String {
    let info = Bundle.main.infoDictionary!
    let key = kCFBundleIdentifierKey as String
    if let identifier = info[key] {
        return (identifier as? String)!
    }
    
    return ""
}

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

enum SecurityClass: Int {
    case genericPassword, internetPassword, certificate, key, identity
    
    func toString() -> CFString {
        switch self {
        case .genericPassword: return kSecClassGenericPassword
        case .internetPassword: return kSecClassInternetPassword
        case .certificate: return kSecClassCertificate
        case .key: return kSecClassKey
        case .identity: return kSecClassIdentity
        }
        
    }
    
}
