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
import UIKit

extension DataSourceManager {
    class func configure() {
        // setup default headers
        let deviceModel = UIDevice.current.model
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        DataSourceManager.addHeaderWithName("Device-Model", value:deviceModel)
        DataSourceManager.addHeaderWithName("App-Version", value:appVersion)
        DataSourceManager.addHeaderWithName("Accept-Language", value:"en-US")
        
        // setup local mode accordingly
        DataSourceManager.localMode = AppSettings.sharedInstance.localMode
        DataSourceManager.baseURLString = AppSettings.sharedInstance.serverURL
        
        // register for settings change notifications
        NotificationCenter.default.registerForSettingsChangeNotificationsWithHandler {
            DataSourceManager.baseURLString = AppSettings.sharedInstance.serverURL
            DataSourceManager.localMode = AppSettings.sharedInstance.localMode
        }
    }
}

extension AKNetworking.Request {
    func challengeHandler(_ handler: @escaping () -> Void) -> Self {
        self.delegate.queue.addOperation {
            if self.response?.statusCode == 401 || self.response?.statusCode == 403 {
                DispatchQueue.main.async {
                    handler()
                }
                
                self.delegate.queue.cancelAllOperations()
            }
        }
        return self
    }
}
