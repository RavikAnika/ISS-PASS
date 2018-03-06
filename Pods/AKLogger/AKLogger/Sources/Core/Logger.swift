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
// MARK: - Constants -
//
//**********************************************************************************************************

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

/**
The LogLevel list.

DEBUG: 
INFO:
NOTICE:
WARNING:
ERROR:
CRITICAL:
ALERT:
EMERGENCY:
NONE:
*/
public enum LogLevel: Int {

    case debug      = 0
    case info       = 1
    case notice     = 2
    case warning    = 3
    case error      = 4
    case critical   = 5
    case alert      = 6
    case emergency  = 7
    case none       = 8
    
    func toString() -> String {
        switch self {
        case .debug:     return "DEBUG"
        case .info:      return "INFO"
        case .notice:    return "NOTICE"
        case .warning:   return "WARNING"
        case .error:     return "ERROR"
        case .critical:  return "CRITICAL"
        case .alert:     return "ALERT"
        case .emergency: return "EMERGENCY"
        case .none:      return "NONE"
        }
        
    }
    
    func toAslLevel() -> Int32 {
        switch self {
        case .debug:     return 7
        case .info:      return 6
        case .notice:    return 5
        case .warning:   return 4
        case .error:     return 3
        case .critical:  return 2
        case .alert:     return 1
        case .emergency: return 0
        case .none:      return -1
        }
        
    }
    
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
Base class for Logger objects. It defines the `logMessage` method signature that all subclasses should 
confirm to and the `logLevel` property that all subclasses must have.
*/
open class Logger {
    
//**************************************************
// MARK: - Properties
//**************************************************
    
    /**
    The log level of the logger object. This value will be compared to the log level passed in to the system
    and will only trigger the writing process if it is bigger than or equal to the system log level.
    The default value for this property is LogLevel.INFO.
    */
    open var logLevel: LogLevel = LogLevel.info
    
//**************************************************
// MARK: - Internal Methods
//**************************************************
    
    /**
    This method should be overrided by any subclass and implement the writing process on the desired 
    destination (such as console or file).
    */
    open func logMessage(_ message: String, logLevel: LogLevel) {
        
    }
    
//**************************************************
// MARK: - Private Methods
//**************************************************

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
