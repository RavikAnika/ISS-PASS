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

// setup the local server
func configureLocalServer() {
    
    // create the server
    let server = LocalServer()
    
    // setup the server's default namespace
    if let namespace = URL(string: AppSettings.sharedInstance.serverURL)?.path {
        _ = server.namespace(namespace)
    }
    
    // enable it as the local server in the networking layer
    DataSourceManager.localServerDelegate = server
    
    server.post("/authenticate", handler: { (request, parameters) -> Response in
        return Response(filename: "authentication", ofType: "json")
    })
    
    server.get("/HelloWorld/:sample", handler: { (request, parameters) -> Response in
        let name = parameters["sample"]!
        return Response(string: "Hello \(name), it's local server!")
    })
}
