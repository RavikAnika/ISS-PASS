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
// MARK: - Definitions -
//
//**********************************************************************************************************

/**
This method uses all Logger objects added from `addLogger` calls. The objects containing the `logLevel` with
value less than or equal to LogLevel.INFO will run write the message to their destination.

- parameter message: The message to be logged. It will be sent by all loggers with appropriate logLevel.

- parameter sender: Object that informs the module from where the Logger objects should be pulled off from.
The object bundle identifier will be used to identify the module. This object should typcally be `self`,
making it possible to separate log messages from different modules or frameworks.

- parameter functionName: The function name to be logged. The default value is the name of the function
calling this method.

- parameter fileName: The name of the file to be logged. The default value is the name of the file that
holds function calling this method.

- parameter lineNumber: The number of the line to be logged. The default value is the number of the line of
this method call.
*/

#if swift(>=2.2)
    public func akLogInfo(_ message: String, sender: AnyObject? = nil, functionName: String = #function,
                          fileName: String = #file, lineNumber: Int = #line) {
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.info, sender: sender)
    }

#else
    public func akLogInfo( message: String, sender: AnyObject? = nil, functionName: String = __FUNCTION__,
    fileName: String = __FILE__, lineNumber: Int = __LINE__) {
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.INFO, sender: sender)
    }
    
#endif

/**
This method uses all Logger objects added from `addLogger` calls. The objects containing the `logLevel` with
value less than or equal to LogLevel.WARNING will run write the message to their destination.

- parameter message: The message to be logged. It will be sent by all loggers with appropriate logLevel.

- parameter sender: Object that informs the module from where the Logger objects should be pulled off from.
The object bundle identifier will be used to identify the module. This object should typcally be `self`, 
making it possible to separate log messages from different modules or frameworks.

- parameter functionName: The function name to be logged. The default value is the name of the function
calling this method.
 
- parameter fileName: The name of the file to be logged. The default value is the name of the file that 
holds function calling this method.
 
- parameter lineNumber: The number of the line to be logged. The default value is the number of the line of 
this method call.
*/
#if swift(>=2.2)
    public func akLogWarn(_ message: String, sender: AnyObject? = nil, functionName: String = #function,
                          fileName: String = #file, lineNumber: Int = #line) {
      
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.warning, sender: sender)
    }

#else
    public func akLogWarn(message: String, sender: AnyObject? = nil, functionName: String = __FUNCTION__,
    fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.WARNING, sender: sender)
    }
    
#endif

/**
This method uses all Logger objects added from `addLogger` calls. The objects containing the `logLevel` with
value less than or equal to LogLevel.DEBUG will run write the message to their destination.

 - parameter message: The message to be logged. It will be sent by all loggers with appropriate logLevel.
 
 - parameter sender: Object that informs the module from where the Logger objects should be pulled off from.
 The object bundle identifier will be used to identify the module. This object should typcally be `self`,
 making it possible to separate log messages from different modules or frameworks.
 
 - parameter functionName: The function name to be logged. The default value is the name of the function
 calling this method.
 
 - parameter fileName: The name of the file to be logged. The default value is the name of the file that
 holds function calling this method.
 
 - parameter lineNumber: The number of the line to be logged. The default value is the number of the line of
 this method call.
*/

#if swift(>=2.2)
    public func akLogDebug(_ message: String, sender: AnyObject? = nil, functionName: String = #function,
                           fileName: String = #file, lineNumber: Int = #line) {
        
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.debug, sender: sender)
    }
    
#else
    public func akLogDebug(message: String, sender: AnyObject? = nil, functionName: String = __FUNCTION__,
    fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.DEBUG, sender: sender)
    }
    
#endif

/**
This method uses all Logger objects added from `addLogger` calls. The objects containing the `logLevel` with
value less than or equal to LogLevel.ERROR will run write the message to their destination.

 - parameter message: The message to be logged. It will be sent by all loggers with appropriate logLevel.
 
 - parameter sender: Object that informs the module from where the Logger objects should be pulled off from.
 The object bundle identifier will be used to identify the module. This object should typcally be `self`,
 making it possible to separate log messages from different modules or frameworks.
 
 - parameter functionName: The function name to be logged. The default value is the name of the function
 calling this method.
 
 - parameter fileName: The name of the file to be logged. The default value is the name of the file that
 holds function calling this method.
 
 - parameter lineNumber: The number of the line to be logged. The default value is the number of the line of
 this method call.
*/

#if swift(>=2.2)
    public func akLogError(_ message: String, sender: AnyObject? = nil, functionName: String = #function,
                           fileName: String = #file, lineNumber: Int = #line) {
        
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.error, sender: sender)
    }
    
#else
    public func akLogError(message: String, sender: AnyObject? = nil, functionName: String = __FUNCTION__,
    fileName: String = __FILE__, lineNumber: Int = __LINE__) {
    
        AKLogger.logMessage("File: \(fileName) - Line: \(lineNumber) \(message)", logLevel: LogLevel.ERROR, sender: sender)
    }
    
#endif
