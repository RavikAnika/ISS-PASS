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

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

let kTokenKey = "SSO.token"
let kExpirationTimeKey = "SSO.time"

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

func bundleIdentifier() -> String {
    let info = Bundle.main.infoDictionary!
    let key = kCFBundleIdentifierKey as String
    if let identifier = info[key] {
        return (identifier as? String)!
    }
    
    return ""
}

public class SSO {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    static let group: String = bundleIdentifier()
    
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
    
    public static func saveToken(_ token: String, expirationTime: Date, forUserAccount userAccount: String = bundleIdentifier(), withOptions options: KeychainOptions = KeychainOptions()) -> NSError? {
        
        if let group = options.group {
            if group.isEmpty == true {
                options.group = SSO.group
            }
            
        }
        
        return Keychain.saveData([kTokenKey: token as NSCoding, kExpirationTimeKey: expirationTime.defaultTimeZone() as NSCoding],
                                 forUserAccount: userAccount, withOptions: options)
        
    }
    
    public static func loadToken(forUserAccount userAccount: String = bundleIdentifier(), options: KeychainOptions = KeychainOptions()) -> String? {
        
        var token: String?
        if let group = options.group {
            if group.isEmpty == true {
                options.group = SSO.group
            }
            
        }
        
        do {
            let data = try Keychain.loadDataForUserAccount(userAccount, withOptions: options)
            
            if let data = data {
                let expirationTime = (data[kExpirationTimeKey] as? Date)?.defaultTimeZone()
                let currentDate = Date().defaultTimeZone()
                
                if currentDate.compare(expirationTime!) == ComparisonResult.orderedAscending {
                    token = (data[kTokenKey] as? String)!
                } else {
                    
                    do {
                        var _ = try Keychain.deleteDataForUserAccount(userAccount, withOptions: options)
                    } catch {
                        return nil
                    }
                    
                }
                
            } else {
                return nil
            }
            
        } catch {
            return nil
            
        }
        
        return token
    }
    
    public static func deleteToken(forUserAccount userAccount: String = bundleIdentifier(), options: KeychainOptions = KeychainOptions()) -> Error? {
        
        if let group = options.group {
            if group.isEmpty == true {
                options.group = SSO.group
            }
            
        }
        
        do {
            try Keychain.deleteDataForUserAccount(userAccount, withOptions: options)
            return nil
        } catch {
            return error
        }
        
    }
    
    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************
    
}

extension Date {
    
    func defaultTimeZone() -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcTimeZoneStr = formatter.string(from: self)
        return formatter.date(from: utcTimeZoneStr) as Date!
    }
    
}
