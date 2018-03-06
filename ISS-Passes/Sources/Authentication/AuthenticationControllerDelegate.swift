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

/// Use a authentication controller delegate to provide behavior when sign in or sign out occurs.
protocol AuthenticatonControllerDelegate {
    /// Called to allow the delegate to perform authentication with the supplied username and password.
    /// - Parameters:
    ///     - authenticationController: The authentication controller
    ///     - username: The username supplied for authentication
    ///     - password: The password supplied for authentication
    ///     - completionHandler: The completion handler for telling the system the result of authentication
    func authenticationController(_ authenticationController: AuthenticationController, authorizeWithUsername username: String, password: String, completionHandler: @escaping(NSError?) -> Void)
    
    /// Called to allow the delegate to perform cleanup after a user is logged out.
    /// - Parameters:
    ///     - authenticationController: The authentication controller
    func authenticationControllerDeauthorize(_ authenticationController: AuthenticationController)
    
    /// Called to allow the delegate the provide the appropriate `Authorization` header.
    /// - Parameters:
    ///     - authenticationController: The authentication controller
    /// - Returns:
    ///     The `Authorization` header value
    func authenticationControllerAuthorizationHeader(_ authenticationController: AuthenticationController) -> String?
}
