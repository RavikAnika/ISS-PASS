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

extension Bundle {
    
    class func printAppVersionBuild() {
        if let
            appVersion: AnyObject = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as AnyObject?,
            let appBuild: AnyObject = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as AnyObject?,
            let appName: AnyObject = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as AnyObject? {
            
            print("\(appName): v\(appVersion) Build: \(appBuild)")
        }
    }
    
    class func printAllEmbeddedFrameworksVersion() {
        // Recursively looking for embedded frameworks
        let sharedFrameworkPath = Bundle.main.bundlePath + "/Frameworks"
        
        let filemanager:FileManager = FileManager()
        let files = filemanager.enumerator(atPath: sharedFrameworkPath)
        while let file: AnyObject = files?.nextObject() as AnyObject? {
            if file.pathExtension == "framework" {
                if let
                    infoDict = NSDictionary(contentsOfFile:"\(sharedFrameworkPath)/" + "\(file)" + "/Info.plist"),
                    let bundleVersion: AnyObject = infoDict.value(forKey: "CFBundleShortVersionString") as AnyObject?,
                    let bundleName: AnyObject = infoDict.value(forKey: "CFBundleName") as AnyObject? {
                    
                    print("\(bundleName).framework: v\(bundleVersion)")
                }
            }
        }
    }
    
    class func printFrameworkVersionFor(_ identifier: String) {
        if let
            bundle = Bundle(identifier: identifier),
            let bundleVersion: AnyObject = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as AnyObject?,
            let bundleName: AnyObject = bundle.object(forInfoDictionaryKey: "CFBundleName") as AnyObject? {
            
            print("\(bundleName).framework: v\(bundleVersion)")
        }
    }
}
