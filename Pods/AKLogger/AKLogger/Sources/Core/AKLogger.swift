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

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
AKLogger class can be used to manage Logger objects. It manages the received messages and sends them to the
correct Logger objects.

Adding multiple loggers allows the application to log information into different destinations (console
and file, for example), with no need to write any additional logic. The `addLogger` method provides a way 
for doing that.

The API offers some useful classes that can be used with this method such as LoggerConsole, LoggerFile,
LoggerASL.
*/
open class AKLogger {
    
//**************************************************
// MARK: - Properties
//**************************************************
    
    fileprivate static let sharedInstance = AKLogger()
    
    fileprivate var rootLoggers: [Logger] = [Logger]()
    
    fileprivate var moduleLoggers: [String : [Logger]] = [String: [Logger]]()
    
//**************************************************
// MARK: - Constructors
//**************************************************
    
    init() {
        let defaultLogger = LoggerConsole()
        defaultLogger.logLevel = LogLevel.warning
        
        rootLoggers.append(defaultLogger)
    }

//**************************************************
// MARK: - Internal Methods
//**************************************************
    
    class func logMessage(_ message: String, logLevel: LogLevel, sender: AnyObject?) {
        
        if let classSender = sender?.classForCoder {
            
            let bundle = Bundle(for: classSender)
            
            if bundle == Bundle.main {
                logToLoggers(message, logLevel: logLevel, loggers: self.sharedInstance.rootLoggers)
            } else {
                let moduleIdentifer = bundle.bundleIdentifier
                if let loggers = self.sharedInstance.moduleLoggers[moduleIdentifer!] {
                    logToLoggers(message, logLevel: logLevel, loggers: loggers)
                } else {
                    logToLoggers(message, logLevel: logLevel, loggers: self.sharedInstance.rootLoggers)
                }
                
            }
            
        } else {
            logToLoggers(message, logLevel: logLevel, loggers: self.sharedInstance.rootLoggers)
        }
        
    }
    
    open class func clearLoggers(_ module: String? = nil) {
        
        if let moduleName = module {
            self.sharedInstance.moduleLoggers[moduleName]?.removeAll()
        } else {
            self.sharedInstance.rootLoggers.removeAll()
        }
        
    }
    
//**************************************************
// MARK: - Private Methods
//**************************************************
    
    fileprivate class func logToLoggers(_ message: String, logLevel: LogLevel, loggers: [Logger]) {
        for logger in loggers {
            if logger.logLevel.rawValue <= logLevel.rawValue {
                logger.logMessage(message, logLevel:  logLevel)
            }
            
        }
        
    }
 
//**************************************************
// MARK: - Self Public Methods
//**************************************************
    
    /**
    Adds a new Logger to the log system.
    */
    open class func addLogger(_ logger: Logger) {
        self.sharedInstance.rootLoggers.append(logger)
    }

    /**
    Adds a new Logger to the log system assigning it for a specific module.

    The module key provides a way of separating log messages for different modules and/or frameworks. This
    allows logs from specific frameworks to not interfeer on the log of other frameworks/files.
    This key should be the bundle identifier of the project that's adding the logger object.
    */
    open class func addLogger(_ logger: Logger, module: String) {
        
        if var loggerArray = self.sharedInstance.moduleLoggers[module] {
            loggerArray.append(logger)
        } else {
            var moduleLoggers = self.sharedInstance.moduleLoggers
            var loggers: [Logger] = []
            loggers.append(logger)
            moduleLoggers[module] = loggers
        }
        
    }

//**************************************************
// MARK: - Override Public Methods
//**************************************************
    
}
