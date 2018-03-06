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
import AKNetworking

/// A custom authentication object that implements authorization for a non-MobileFirst Platform backend. Customize this class if not integrating with the MobileFirst Platform.
class Authenticator: AuthenticatonControllerDelegate {
    fileprivate var token: String?
    
    // MARK: - Authentication controller delegate methods
    
    func authenticationController(_ authenticationController: AuthenticationController, authorizeWithUsername username: String, password: String, completionHandler: @escaping (NSError?) -> Void){
        
        _ = DataSourceManager.request(.POST, "/authenticate", parameters: ["username": username as AnyObject, "password": password as AnyObject], encoding: .json).validate().responseJSON { (_, _, json, error) -> Void in
            self.token = json["response"]["Authorization"].stringValue
            completionHandler(error)
        }
        
    }
    func authenticationControllerDeauthorize(_ authenticationController: AuthenticationController){
        
    }
    
    func authenticationControllerAuthorizationHeader(_ authenticationController: AuthenticationController) -> String?{
        return self.token
    }
}
