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
import AKKeychain

extension BaseLoginViewController {

//**************************************************
// MARK: - Private Methods
//**************************************************

//**************************************************
// MARK: - Internal Methods
//**************************************************

//**************************************************
// MARK: - Self Public Methods
//**************************************************

    /**
    Save token on keychain with expiration time.
    
    - parameter token: Token to be written to the keychain.
    - parameter expirationTime: Token expiration time to be written to the keychain.
    - parameter userAccount: User account under which the text value is stored in the keychain. By default
    the bundle identifier is used.
    - parameter options: Value that indicates when your app will save the keychain item. By default the
    .GenericPassword option is used to store a generic password and group is bundle name.
    
    - returns: NSError if the token was unsuccessfully written to the iOS Keychain or nil if
    the item was successfully saved.
    */
    public func saveToken(_ token: String, expirationTime: Date, forUserAccount userAccount: String = bundleIdentifier(), withOptions options: KeychainOptions = KeychainOptions()) -> NSError? {

            return SSO.saveToken(token, expirationTime: expirationTime, forUserAccount: userAccount,
                withOptions: options)
    }

    /**
    Load token from iOS Keychain corresponding the user account and group.
    
    - parameter userAccount: The user account that is used to read the token on iOS Keychain item.
    - parameter options: Value that indicates when your app will save the keychain item. By default the
    .GenericPassword option is used to store as generic password and group is bundle name.
    
    - returns: Token string.
    */
    public func loadToken(forUserAccount userAccount: String = bundleIdentifier(), withOptions options: KeychainOptions = KeychainOptions()) -> NSString? {

            return SSO.loadToken(forUserAccount: userAccount, options: options) as NSString?
    }

    /**
    Delete token from iOS Keychain corresponding the user account and group.
    
    - parameter userAccount: The user account that is used to read the token on iOS Keychain item.
    - parameter options: Value that indicates when your app will save the keychain item. By default the
    .GenericPassword option is used to store as generic password and group is bundle name.
    
    - returns: NSError if the token was unsuccessfully removed to the iOS Keychain or nil if
    the item was successfully deleted.
    */
    public func deleteToken(forUserAccount userAccount: String = bundleIdentifier(), withOptions options: KeychainOptions = KeychainOptions()) -> Error? {

            return SSO.deleteToken(forUserAccount: userAccount, options: options)
    }

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
