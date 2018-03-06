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
Subclass of Logger class that logs information into the console. It allows the customization of the date
formatter used when printing the logs.
*/
open class LoggerConsole: Logger {
    
//**************************************************
// MARK: - Properties
//**************************************************
    
    let dateFormatter: DateFormatter
    
//**************************************************
// MARK: - Constructors
//**************************************************
    
    /**
    Initializes a LoggerConsole with a default NSDateFormatter.
    The default date formatter uses NSDateFormatterStyle.ShortStyle for `dateStyle` and
    NSDateFormatterStyle.ShortStyle for `timeStyle`.
    */
    public override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = .short
        
        super.init()
    }
    
    /**
    Initializes the LoggerConsole with a custom NSDateFormatter.
    
    - parameter customDateFormatter: NSDateFormatter that will be used to format the date composing the log
    message.
    */
    public init(customDateFormatter: DateFormatter) {
        self.dateFormatter = customDateFormatter
        super.init()
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
    Logs the message into the console.
    
    - parameter message: The message to be logged into the console.
    - parameter logLevel: The log level information will be prepended into the message before the message
    is printed.
    */
    override open func logMessage(_ message: String, logLevel: LogLevel) {
        if logLevel.rawValue < self.logLevel.rawValue {
            return
        }
        
        let date = Date()
        let dateStr = dateFormatter.string(from: date)
        
        print("[\(dateStr)] - [\(logLevel.toString())] - \(message)")
    }
    
}
