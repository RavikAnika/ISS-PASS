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
import UIKit

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

let serverURL = "https://devicetracker.mybluemix.net/register"
let authorizationToken = "MFToken ZGVmaWJhbnNhbEBpbi5pYm0uY29tOjEyMzQ1NkFh"
let defaultUpdateInterval: TimeInterval = 60 * 60 * 24 // default every 24hr
let domain = "com.ibm.mobilefirst.frameworks.Lighthouse"

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

public protocol InstanceCounterDelegate {
    
    /**
     Called when InstanceCounter has a response of server.
     */
    func didUpdateCounter()
    
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

public class InstanceCounter: NSObject {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    
    private var task: URLSessionDataTask?
    
    private var timer: Timer?
    
    static var bundleIdentifierLoader: () -> String? = {
        return {
            return Bundle.main.bundleIdentifier
        }
    }()
    
    var request: NSURLRequest {
        // create the request
        let request = NSMutableURLRequest(url: NSURL(string: serverURL)! as URL)
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = queryParameters.data(using: String.Encoding.utf8)
        
        print(queryParameters)
        return request
    }
    
    var queryParameters: String {
        // build the JSON
        var payload = [
            "applicationID": applicationID,
            "deviceID": deviceID]
        
        if let customerID = self.customerID {
            payload["customerID"] = customerID
        }
        
        return queryStringForParameters(parameters: payload as [String : AnyObject])
    }
    
    public static let sharedInstance = InstanceCounter()
    
    public internal(set) var lastUpdated: NSDate? {
        set {
            UserDefaults.standard.set(newValue, forKey: domain + ".lastUpdated")
        }
        get {
            return UserDefaults.standard.object(forKey: domain + ".lastUpdated") as? NSDate
        }
    }
    
    public private(set) var applicationID: String
    
    public private(set) var deviceID: String
    
    public private(set) var customerID: String?
    
    public var updateInterval: TimeInterval = defaultUpdateInterval {
        didSet {
            // only update the timer is one already exists, meaning the session has been started
            if let _ = timer { setupTimer() }
        }
    }
    
    public var delegate: InstanceCounterDelegate?
    
    
    
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    private override init() {
        // assign the application ID
        if let appID = InstanceCounter.bundleIdentifierLoader() {
            self.applicationID = appID
        } else {
            fatalError("Unable to load bundle identifier for default application ID")
        }
        
        // grab the device ID
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            self.deviceID = deviceID
        } else {
            fatalError("Unable to determine device identifier")
        }
    }
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Internal Methods
    //**************************************************
    
    func setupTimer() {
        timer?.invalidate()
        timer = Timer.schedule(repeatInterval: updateInterval, handler: { timer in
            self.updateRemoteServer()
        })
    }
    
    func updateRemoteServer() {
        // protect against sending within the update period
        if let lastUpdated = self.lastUpdated {
            guard NSDate().timeIntervalSince(lastUpdated as Date) > updateInterval else { return }
        }
        
        // protect against sending while a request is already in flight
        if let task = self.task {
            guard task.state == .completed else { return }
        }
        
        // send the request
        let session = URLSession.shared
        
        task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            self.lastUpdated = NSDate()
            self.task = nil
            DispatchQueue.main.async {
                self.delegate?.didUpdateCounter()
            }
        }
        
        task?.resume()
    }
    
    func queryStringForParameters(parameters: [String: AnyObject]) -> String {
        
        func escape(string: String) -> String {
            return string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        }
        
        var parts: [String] = []
        for (name, value) in parameters {
            let queryParam = escape(string: "\(name)")
            let queryValue = escape(string: "\(value)")
            parts.append("\(queryParam)=\(queryValue)")
        }
        return parts.joined(separator: "&")
    }
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    public func startSessionWithCustomerID(customerID: String, applicationID: String? = nil) {
        
        // save the customer ID and app ID
        self.customerID = customerID
        
        // assign the application ID if passed
        if let appID = applicationID {
            self.applicationID = appID
        }
        
        // remove previous registration
        NotificationCenter.default.removeObserver(self)
        
        // register for active notification
        NotificationCenter.default.addObserver(self, selector: #selector(InstanceCounter.updateRemoteServer),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        // setup the timer
        setupTimer()
        
        // update immediately
        updateRemoteServer()
    }
    
    public func forceUpdate() {
        lastUpdated = nil
        updateRemoteServer()
    }
    
    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************
    
}
