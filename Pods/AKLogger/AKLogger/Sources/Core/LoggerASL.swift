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
import asl

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

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
 This is a wrapper for the Apple System Log facility, providing an easier way of using it. The messages
 logged by this class are stored in the system log data store, which permits advanced browsing.
 
 Although all the abstraction is provided, a better understanting of the ASL can be found here:
 https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man3/asl.3.html
 */
open class LoggerASL: Logger {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    let client: aslclient//aslclient
    let sender: String = (Bundle.main.infoDictionary!["CFBundleName"] as? String)!
    let facility: String = "com.apple.console"
    
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    /**
     Initializes a LoggerASL logger.
     */
    public override init() {
        // self.client = os_log_create(self.sender, self.facility, UInt32(ASL_OPT_NO_DELAY))
        self.client = asl_open(self.sender, self.facility, UInt32(ASL_OPT_NO_DELAY))
        asl_open(self.sender, self.facility, UInt32(ASL_OPT_NO_DELAY))
    }
    
    //**************************************************
    // MARK: - Internal Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************
    
    /**
     Logs a message to the ASL server.
     
     - parameter message: The message to be logged to the server.
     - parameter logLevel: The log level information will be prepended into the message before the message
     is printed.
     */
    override open func logMessage(_ message: String, logLevel: LogLevel) {
        
        let asl_msg = asl_new(UInt32(ASL_TYPE_MSG))
        
        asl_set(asl_msg, ASL_KEY_MSG, "asl test output")
        asl_set(asl_msg, ASL_KEY_LEVEL, "\(logLevel.toAslLevel())")
        
        asl_send(client, asl_msg)
        asl_free(asl_msg)
    }
    
}
