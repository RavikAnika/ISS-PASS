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
import Security
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

public let keychainErrorDomain = "com.ibm.mobilefirst.frameworks.AKKeychain"
public let defaultKeychainService = Bundle.main.infoDictionary?[kCFBundleIdentifierKey as String] as? String ?? "AKKeychain"
public let defaultSecurityClass = SecurityClass.genericPassword
public let defaultAuthType = AuthType.noAuth
public let defaultSecurityAccessType = SecurityAccessType.whenPasscodeSetThisDeviceOnly

public enum SecurityClass: Int {
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

public enum SecurityAccessType: Int {
    case whenUnlocked
    case afterFirstUnlock
    case always
    case whenPasscodeSetThisDeviceOnly
    case whenUnlockedThisDeviceOnly
    case afterFirstUnlockThisDeviceOnly
    case alwaysThisDeviceOnly

    func toString() -> CFString {
        switch self {
        case .whenUnlocked: return kSecAttrAccessibleWhenUnlocked
        case .afterFirstUnlock: return kSecAttrAccessibleAfterFirstUnlock
        case .always: return kSecAttrAccessibleAlways
        case .whenPasscodeSetThisDeviceOnly: return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .whenUnlockedThisDeviceOnly: return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .afterFirstUnlockThisDeviceOnly: return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .alwaysThisDeviceOnly: return kSecAttrAccessibleAlwaysThisDeviceOnly
        }
        
    }
    
}

public enum AuthType: Int {
	case noAuth, touchID
}

public enum KeychainError: Error {
	case code(Int32), touchIDFailure, touchIDUnavailable
}

//**********************************************************************************************************
//
// MARK: - Class - Keychain
//
//**********************************************************************************************************

/**
The Keychain class provides a Swift wrapper for reading, writing and deleting a dictionary from iOS Keychain.
*/
public class Keychain {

	//**************************************************
	// MARK: - Properties
	//**************************************************

	//**************************************************
	// MARK: - Constructors
	//**************************************************

	//**************************************************
	// MARK: - Internal Methods
	//**************************************************

	//**************************************************
	// MARK: - Private Methods
	//**************************************************

	//**************************************************
	// MARK: - Self Public Methods
	//**************************************************

	/**
	Stores data in the keychain item under the given user account.
	
	- parameter data: Data to be written to the keychain.
	- parameter userAccount: User account under which the text value is stored in the keychain.
	- parameter options: Value that indicates when your app will save the keychain item. By default the
	.GenericPassword option is used to store a generic password.
	
	- returns: NSError if the text was unsuccessfully written to the iOS Keychain or nil if
	the item was successfully saved.
	*/

    open class func saveData(_ data: [String: NSCoding], forUserAccount userAccount: String, withOptions options: KeychainOptions = KeychainOptions()) -> NSError? {
        var error: NSError? = nil
        // create the base attributes from the request
        let attributes = newAttributes(userAccount, requestOptions: options)
        // add the request data
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
        attributes.setObject(encodedData, forKey: (kSecValueData as? NSCopying)!)
        // delete existing first
        SecItemDelete(attributes)
        // add new data
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemAdd(attributes, UnsafeMutablePointer($0))
        }
        
        // check for errors
        if status != errSecSuccess {
            error = NSError(domain: keychainErrorDomain, code: Int(status), userInfo: nil)
        }

        return error
    }
	/**
	Update data from iOS keychain.
	- parameter query:This parameter is used to control the search, you should specify the items
	that you want to change.
	- parameter attributesToUpdate: This parameter should contain the items that the values ​​should be
	changed along with the new values.
	
	- returns: NSError if the text was unsuccessfully written to the iOS Keychain or nil if
	the item was successfully update.
	
	*/
	open class func updateData(_ query: [String: NSCoding],
	                           withAttributesToUpdate attributesToUpdate: [String: NSCoding], withUserAccount userAccount: String, withOptions options: KeychainOptions = KeychainOptions()) throws {

        if options.authType == AuthType.touchID {
			try authWithTouchID("Validating biometrics")
		}
		let attributes = newAttributes(userAccount, requestOptions: options)
		let encodedData = NSKeyedArchiver.archivedData(withRootObject: query)
		attributes.setObject(encodedData, forKey: (kSecValueData as? NSCopying)!)
		var codeResult = SecItemCopyMatching(attributes, nil)
		if codeResult == noErr {
			print("\(attributesToUpdate)")
			let encodedData = NSKeyedArchiver.archivedData(withRootObject: attributesToUpdate)
			let newAttributes = NSMutableDictionary()
			newAttributes.setObject(encodedData, forKey: (kSecValueData as? NSCopying)!)

			codeResult = SecItemUpdate(attributes, newAttributes)

			if codeResult != errSecSuccess {
				throw KeychainError.code(codeResult)
			}
		}
	}

	/**
	Loads data from iOS Keychain corresponding the user account.
	
	- parameter userAccount: The user account that is used to read the iOS Keychain item.
	- parameter options: Value that indicates when your app will save the keychain item. By default the
	.GenericPassword option is used to store as generic password.
	
	- returns: A Tuple ([String:NSCoding], NSError) correspondent to data and error info when it fails to
	load data from iOS Keychain.
	*/
	open class func loadDataForUserAccount(_ userAccount: String, withOptions options: KeychainOptions = KeychainOptions()) throws -> [String: NSCoding]? {

		if options.authType == AuthType.touchID {
			try authWithTouchID("Validating biometrics")
		}
		// create the base attributes from the request
		let attributes = newAttributes(userAccount, requestOptions: options)

		// set options to match one and return the data
		attributes.setObject(kCFBooleanTrue, forKey: (kSecReturnData as? NSCopying)!)
		attributes.setObject(kSecMatchLimitOne, forKey: (kSecMatchLimit as? NSCopying)!)
		// read the data
		var result: AnyObject?
		let status = withUnsafeMutablePointer(to: &result) {
			SecItemCopyMatching(attributes, UnsafeMutablePointer($0))
		}
		var dict: [String: NSCoding]?

		// bind the resulting data
		if let data = result as? Data {
			dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: NSCoding]
		}

		// check for error
		if status != errSecSuccess {

			throw KeychainError.code(status)

		}

		return (dict)!
	}
    
    /**
     Loads shared data from iOS Keychain corresponding the user account and group name.
     
     - parameter userAccount: The user account that is used to read the iOS Keychain item.
     - parameter options: Value that indicates when your app will save the keychain item. By default the
     .GenericPassword option is used to store as generic password.
     
     - returns: A Tuple ([String:NSCoding], NSError) correspondent to data and error info when it fails to
     load data from iOS Keychain.
     */
    
    open class func loadSharedDataForUserAccount(_ userAccount: String, withOptions options: KeychainOptions = KeychainOptions()) throws -> [String: NSCoding]? {

        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userAccount as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessGroup as String: options.group as AnyObject
        ]
        
        // read the data
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }
        var dict: [String: NSCoding]?
        
        // bind the resulting data
        if let data = result as? Data {
            dict = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: NSCoding]
        }
        
        // check for error
        if status != errSecSuccess {
            
            throw KeychainError.code(status)
            
        }
        
        return (dict)!
    }

	/**
	Deletes data from iOS Keychain specified by the user account.
	
	- parameter userAccount: The user account that is used to delete the keychain item.
	- parameter options: Value that indicates when your app will delete the keychain item. By default the
	.GenericPassword option is used to store as generic password.
	
	- returns: NSError if the item was unsuccessfully deleted or nil if successfully deleted.
	*/
	open class func deleteDataForUserAccount(_ userAccount: String, withOptions options: KeychainOptions = KeychainOptions()) throws {

		if options.authType == AuthType.touchID {
			try authWithTouchID("Validating biometrics")
		}

		// create the base attributes from the request
		let attributes = newAttributes(userAccount, requestOptions: options)

		// delete
		let status = SecItemDelete(attributes)

		// check for errors
		if status != errSecSuccess {

			throw KeychainError.code(status)
		}
	}

}

extension Keychain {
	open class func newAttributes(_ userAccount: String, requestOptions: KeychainOptions) -> NSMutableDictionary {
		let attributes = NSMutableDictionary()
		var options = [String: String?]()
		options[String(kSecAttrAccount)] = userAccount
		options[String(kSecAttrAccessGroup)] = requestOptions.group
		options[String(kSecAttrService)] = requestOptions.service
		options[String(kSecClass)] = requestOptions.securityClass.toString() as String
		for (key, option) in options {
			if let option: String = option {
				attributes.setObject(option, forKey: key as NSCopying)
			}
		}
        
        let secAccess = requestOptions.securityAccessType
        if let secAccessControlRef = SecAccessControlCreateWithFlags(kCFAllocatorDefault, secAccess as CFTypeRef, .userPresence, nil) {
            attributes.setObject(secAccessControlRef, forKey: String(kSecAttrAccessControl) as NSCopying)
        }
		return attributes
	}

    @discardableResult
	open class func authWithTouchID(_ reason: String) throws -> Bool {

		var localError: KeychainError? = nil
		var processed: Bool = false

		let context = LAContext()
		let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

		if context.canEvaluatePolicy(policy, error: nil) {

			context.evaluatePolicy(policy, localizedReason: reason) { (success, _) in

				if success {
					processed = true
				} else {
					localError = KeychainError.touchIDFailure
					processed = true
				}
			}
		} else {
			localError = KeychainError.touchIDUnavailable
			processed = true
		}
		while processed == false {
			RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.2))
		}

		if let error = localError {
			throw error
		}

		return true
	}
    
}

//**********************************************************************************************************
//
// MARK: - Class - KeychainOptions
//
//**********************************************************************************************************

/**
KeychainOptions class provides the options values for use with Keychain class.
*/
public class KeychainOptions {
	//**************************************************
	// MARK: - Properties
	//**************************************************

	public var service: String = defaultKeychainService
	public var group: String?
	public var securityClass: SecurityClass = defaultSecurityClass
	public var authType: AuthType = defaultAuthType
    public var securityAccessType: SecurityAccessType = defaultSecurityAccessType
	//**************************************************
	// MARK: - Constructors
	//**************************************************
	public init() {
    }

	//**************************************************
	// MARK: - Self Public Methods
	//**************************************************
	/**
	Set new service value to use to save items.
	
	- parameter service: String value to save in the service.
	
	- returns: Return it self.
	*/
	public func service(_ service: String) -> Self {
		self.service = service
		return self
	}
	/**
	Set new group value to use to share items.
	
	- parameter group: String value to save in the group.
	
	- returns: Return it self.
	*/
	public func group(_ group: String) -> Self {
		self.group = group
		return self
	}
	/**
	Set new SecurityClass value enum to indicates when your app will save the keychain item.
	
	- parameter securityClass: SecurityClass enum value to save in the securityClass.
	
	- returns: Return it self.
	*/
	public func securityClass(_ securityClass: SecurityClass) -> Self {
		self.securityClass = securityClass
		return self
	}
	/**
	Set new AuthType value enum to indicates the authentication method.
	
	- parameter authType: AuthType enum value to save in the authType.
	
	- returns: Return it self.
	*/
	public func authType(_ authType: AuthType) -> Self {
		self.authType = authType
		return self
	}
    
    /**
     Set new SecurityAccessType value enum to indicates the security for the data stored in keychain.
     
     - parameter securityAccessType: SecurityAccessType enum value to save in the authType.
     
     - returns: Return it self.
     */
    public func securityAccessType(_ securityAccessType: SecurityAccessType) -> Self {
        self.securityAccessType = securityAccessType
        return self
    }
	
}
