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

enum Request: AuthenticationControllerAccessible {
    typealias LAT = Double
    typealias LON = Double
    case getPasses(LAT, LON)
//
//    func execute() -> AKNetworking.Request {
//        // build the actual request
//        let request: AKNetworking.Request
//        switch self {
//        case .getPasses (let LAT , let LON): break
//
//        }
//
//        // log the response
//        _ = request.responseString { (urlRequest, urlResponse, string, error) -> Void in
//            // use this closure to log the response
//        }
//
//        // check for challenge handler
//        _ = request.challengeHandler { () -> Void in
//            self.authenticationController?.signOut()
//        }
//
//        return request
//    }
    
    fileprivate var headers: [String: String] {
        var headers: [String: String] = [:]
        
        // add the cached authorization header
        if let authorizationHeader = self.authenticationController?.authorizationHeader {
            headers["Authorization"] = authorizationHeader
        }
        
        return headers
    }
}
