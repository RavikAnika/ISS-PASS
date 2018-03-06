/*
 * Assembly Kit
 * Licensed Materials - Property of IBM
 * Copyright (C) 2016 IBM Corp. All Rights Reserved.
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
import LocalAuthentication

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

public enum MFAError {

    case authenticationFailed
    case userCancel
    case userFallback
    case systemCancel
    case passcodeNotSet
    case touchIDNotAvailable
    case touchIDNotEnrolled
    case unableToAuthenticate

    var description: String {
        switch self {

        case .authenticationFailed: return kAlertTouchIDAuthenticationFailed
        case .userCancel: return kAlertTouchIDCancelled
        case .userFallback: return kAlertTouchIDFallbackTitle
        case .systemCancel: return kAlertTouchIDCancelled
        case .passcodeNotSet: return kAlertTouchIDUnsuccessful
        case .touchIDNotAvailable: return kAlertTouchIDNotAvailable
        case .touchIDNotEnrolled: return kAlertTouchIDNotEnrolled
        case .unableToAuthenticate: return kAlertTouchIDUnableAuthenticate
        }
        
    }
    
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

class MultiFactorAuthentication {

    //**************************************************
    // MARK: - Properties
    //**************************************************

    //**************************************************
    // MARK: - Constructors
    //**************************************************

    //**************************************************
    // MARK: - Private Methods
    //**************************************************

    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************

    class func authenticate( _ completion: @escaping (_ success: Bool, _ error: MFAError?) -> Void ) {

        let touchIDContext: LAContext = LAContext()

        touchIDContext.localizedFallbackTitle = kAlertTouchIDFallbackTitle

        var error: NSError?
        var mfaError: MFAError?

        if touchIDContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                            error: &error) {
            // check fingerprint as device owner
            touchIDContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                          localizedReason: kAlertTouchIDReasonString, reply: {
                                            (success: Bool, error: Error?) -> Void in

                                            // note: the block is executed on a private queue internal to the framework in an
                                            // unspecified threading context

                                            if let errorResult = error as NSError? {

                                                switch errorResult.code {

                                                case LAError.Code.authenticationFailed.rawValue:
                                                    mfaError = MFAError.authenticationFailed

                                                case LAError.Code.userCancel.rawValue:
                                                    mfaError = MFAError.userCancel

                                                case LAError.Code.userFallback.rawValue:
                                                    mfaError = MFAError.userFallback

                                                case LAError.Code.systemCancel.rawValue:
                                                    mfaError = MFAError.systemCancel

                                                case LAError.Code.touchIDNotAvailable.rawValue:
                                                    mfaError = MFAError.touchIDNotAvailable

                                                case LAError.Code.touchIDNotEnrolled.rawValue:
                                                    mfaError = MFAError.touchIDNotEnrolled

                                                case LAError.Code.passcodeNotSet.rawValue:
                                                    mfaError = MFAError.passcodeNotSet

                                                default:
                                                    mfaError = MFAError.unableToAuthenticate
                                                }

                                                completion (success, mfaError)

                                            } else {

                                                completion (success, nil)
                                            }
                                            
            })
        } else {
            print("Can not Evaluate")
            completion (false, MFAError.touchIDNotAvailable)
        }
        
    }

    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************

}
