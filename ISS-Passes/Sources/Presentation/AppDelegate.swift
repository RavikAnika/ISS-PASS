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

import UIKit
import AKNetworking

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    
    let instanceCounterID: String = "YOUR_CUSTOMER_ID"
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        InstanceCounter.sharedInstance.delegate = self
//        InstanceCounter.sharedInstance.startSessionWithCustomerID(customerID: instanceCounterID)
        
        if let window = self.window {
            // setup the root view
            window.rootViewController = AuthenticationController()
            window.makeKeyAndVisible()
            
            //print app & framework versions
            displayVersions()
            
            // set the global tint
            window.tintColor = StyleKit.defaultTint
            
            // run on first application launch
            AppSettings.sharedInstance.runHandlerOnLaunch({ (firstLaunch: Bool, lastLaunchVersion: String?, currentVersion: String) -> Void in
                
                // handle anything you want to happen on application launch - such as schema upgrades, notification registration etc
            })
            
            // setup the networking stack
            DataSourceManager.configure()
            // setup up the local server
            configureLocalServer()
        }
        
        return true
    }
    
    func displayVersions() {
        Bundle.printAppVersionBuild()
        Bundle.printAllEmbeddedFrameworksVersion()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Called when the application is about to become active.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate : InstanceCounterDelegate {
    func didUpdateCounter() {
        print("didUpdateCounter")
    }
}
