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

class AppSettings {
    fileprivate struct Defaults {
        static let firstLaunchKey = "AppSettings.Defaults.firstLaunchKey"
        static let localModeKey = "AppSettings.Defaults.localModeKey"
        static let serverURL = "AppSettings.Defaults.serverURL"
        static let versionOfLastRun = "AppSettings.Defaults.versionOfLastRun"
    }
    
    static let sharedInstance = AppSettings()
    
    var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var localMode: Bool {
        return UserDefaults.standard.bool(forKey: Defaults.localModeKey)
    }
    
    var serverURL: String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: Defaults.serverURL)
        }
        
        get {
            return UserDefaults.standard.string(forKey: Defaults.serverURL) ?? ""
        }
    }
    
    func runHandlerOnLaunch(_ handler: (_ firstLaunch: Bool, _ lastLaunchVersion: String?, _ currentVersion: String) -> Void ) {
        // grab user defaults
        let userDefaults = UserDefaults.standard
        
        // register the default options
        let defaultOptions: [String: AnyObject] = [
            Defaults.firstLaunchKey: true as AnyObject,
            Defaults.localModeKey: true as AnyObject,
            Defaults.serverURL: "http://httpbin.org" as AnyObject,
            ]
        userDefaults.register(defaults: defaultOptions)
        
        // handle first launch/updated version
        let firstLaunch = userDefaults.bool(forKey: Defaults.firstLaunchKey)
        let lastLaunchVersion = userDefaults.string(forKey: Defaults.versionOfLastRun)
        let currentVersion = version
        
        userDefaults.set(false, forKey: Defaults.firstLaunchKey)
        userDefaults.set(currentVersion, forKey: Defaults.versionOfLastRun)
        
        handler(firstLaunch, lastLaunchVersion, currentVersion)
    }
}

extension NotificationCenter {
    func registerForSettingsChangeNotificationsWithHandler(_ handler: @escaping () -> Void) {
        self.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main) { (notification) -> Void in
            handler()
        }
    }
}
