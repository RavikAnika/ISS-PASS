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
import MobileCoreServices

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
 DataSourceManager is responsible of handling server requests.
 */
public class DataSourceManager: NSObject {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    public static var sharedInstance: DataSourceManager = DataSourceManager()
    
    /**
     It's the delegate for local server, it'll be the responsible for handling all the local API requests
     */
    public class var localServerDelegate: LocalServerDelegate? {
        set {
            SessionManager.sharedInstance.localServerDelegate = newValue
        }
        
        get {
            return SessionManager.sharedInstance.localServerDelegate
        }
        
    }
    
    public var serverPolicyManager: ServerPolicyManager?
    
    /**
     This base string is the domain for which all the requests will be redirected.
     For Example, setting this property to "http://mydomain.com" and later calling
     DataSourceManager.request(.POST, "/user/123", parameters:...) will actually make a call to
     "http://mydomain.com/user/123"
     */
    public class var baseURLString: String? {
        set {
            SessionManager.sharedInstance.baseURLString = newValue
        }
        
        get {
            return SessionManager.sharedInstance.baseURLString
        }
        
    }
    
    /**
     Indicates if the DataSourceManager is currenctly running on local mode.
     When running on local mode you must set the localServerDelegate in order to handle the request.
     */
    public class var localMode: Bool {
        set {
            SessionManager.sharedInstance.localMode = newValue
        }
        
        get {
            return SessionManager.sharedInstance.localMode
        }
        
    }
    
    /**
     Responsible by the cache policy with request. Default value is UseProtocolCachePolicy.
     */
    public class var cachePolicy: NSURLRequest.CachePolicy! {
        set {
            SessionManager.sharedInstance.cachePolicy = newValue
        }
        
        get {
            return SessionManager.sharedInstance.cachePolicy
        }
        
    }
    
    /**
     Defines a cache control globally for any request.
     */
    public class var cacheControl: RequestCacheControl? {
        set {
            SessionManager.sharedInstance.cacheControl = newValue
        }
        
        get {
            return SessionManager.sharedInstance.cacheControl
        }
        
    }
    
    /**
     Defines a SessionConfiguration for session.
     */
    public class var sessionConfiguration: SessionConfiguration {
        set {
            SessionManager.sessionConfiguration = newValue
        }
        
        get {
            return SessionManager.sessionConfiguration
        }
        
    }
    
    /**
     Defines a request cache session  for session.
     */
    public class var enableRequestCache: Bool {
        set {
            SessionManager.enableRequestCacche = newValue
        }
        
        get {
            return SessionManager.enableRequestCacche
        }
        
    }
    
    /**
     Defines a url cache session for session.
     */
    public class var enableURLCache: Bool {
        set {
            SessionManager.enableURLCache = newValue
        }
        
        get {
            return SessionManager.enableURLCache
        }
        
    }
    
    /**
     Defines a response validator for any request. The Response Validator is responsible for
     denying responses that doesn't fit into the define validation rules.
     */
    public var responseValidator: ResponseValidator? {
        set {
            SessionManager.sharedInstance.responseValidator = newValue
        }
        
        get {
            return SessionManager.sharedInstance.responseValidator
        }
        
    }
    
    //**************************************************
    // MARK: Timeout interval
    //**************************************************
    
    /**
     property that controles the timeout from http connections
     */
    public class var timeoutInterval: TimeInterval? {
        set {
            SessionManager.sharedInstance.timeoutInterval = newValue
        }
        
        get {
            return SessionManager.sharedInstance.timeoutInterval
        }
        
    }
    
    /**
     property that controls the response delay from local requests
     */
    public class var localResponseDelayInterval: TimeInterval {
        set {
            SessionManager.sharedInstance.localResponseDelayInterval = newValue
        }
        
        get {
            return SessionManager.sharedInstance.localResponseDelayInterval
        }
        
    }
    
    /**
     The timeout interval to use when waiting for additional data in session. Default value is 60 seconds.
     */
    public class var timeoutSessionIntervalForRequest: TimeInterval {
        set {
            SessionManager.timeoutSessionIntervalForRequest = newValue
        }
        
        get {
            return SessionManager.timeoutSessionIntervalForRequest
        }
        
    }
    
    /**
     The maximum amount of time that a resource request should be allowed to take. Default value is 7 days.
     */
    public class var timeoutSessionIntervalForResource: TimeInterval {
        set {
            SessionManager.timeoutSessionIntervalForResource = newValue
        }
        
        get {
            return SessionManager.timeoutSessionIntervalForResource
        }
        
    }
    
    /**
     The maximum file size(in KB's) that is allowed for uploading to server. Default value is 2048 KB's.
     */
    public class var maximumFileSizeAllowedForUploading: Int {
        set {
            SessionManager.maximumFileSizeAllowedForUploading = newValue
        }
        
        get {
            return  SessionManager.maximumFileSizeAllowedForUploading
        }
        
    }
    
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Internal Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    //*************************
    // Request proxy methods
    //*************************
    
    /**
     Creates a Request using the suplied parameters value.
     
     - parameter method:     The Method that should be used to make this request.
     - parameter urlString:  The url that you want to send the request.
     - parameter parameters: Parameters for the request. This parameter can be implied and defaults to nil.
     - parameter encoding:   Encoding that should be used on this request. This parameter can be implied and
     defaults to JSON.
     - parameter headers:    HTTP Headers for the request. This parameter is can be implied and defaults to
     nil.
     
     - returns: a Request object that represents this request.
     */
    public class func request(_ method: Method, _ urlString: String, parameters: [String: AnyObject]? = nil,
                              encoding: ParameterEncoding = .json, headers: [String: String]? = nil) -> Request {
        
        return SessionManager.sharedInstance.request(method, urlString, parameters: parameters, encoding: encoding, headers: headers)
    }
    
    /**
     Creates a File Upload Request using the suplied parameters value.
     
     - parameter urlString:  The url that you want to send the request.
     - parameter parameters: Parameters for the request. This parameter can be implied and defaults to nil.
     - parameter headers:    HTTP Headers for the request. This parameter is can be implied and defaults to
     - parameter uploadClosure: Closure to get upload progress and error status message.
     nil.
     
     - returns: a Request object that represents this request.
     */
    public class func multipartUploadRequest(urlString: String, parameters: [String: AnyObject]? = nil, headers: [String: String]? = nil, uploadClosure: @escaping (_ error: String, _ progressStatus: String) -> Void  ) -> Request? {
        return SessionManager.sharedInstance.multipartUploadRequest(urlString: urlString, parameters: parameters, headers: headers, closure: uploadClosure)
    }
    
    /**
     Creates a request using a manually created NSURLRequest.
     
     - parameter urlRequest: A NSURLRequest with the request details.
     
     - returns: a Request object that represents this request.
     */
    public class func request(_ urlRequest: URLRequest) -> Request {
        return SessionManager.sharedInstance.request(urlRequest)
    }
    
    //*************************
    // Header methods
    //*************************
    
    /**
     Adds a header (name/value pair) to the stored array.
     
     - parameter name:  name of the header to be added.
     - parameter value: value of the header.
     */
    public class func addHeaderWithName(_ name: String, value: String) {
        SessionManager.sharedInstance.headers[name] = value
    }
    
    /**
     Remove a header (name and value pair) from the headers array.
     
     - parameter name: the name of the Header to be removed.
     */
    public class func removeHeaderWithName(_ name: String) {
        SessionManager.sharedInstance.headers.removeValue(forKey: name)
    }
    
    /**
     Remove all headers from headers array.
     */
    public class func removeAllHeaders() {
        SessionManager.sharedInstance.headers.removeAll(keepingCapacity: false)
    }
    
}
