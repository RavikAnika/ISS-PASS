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

import UIKit

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
// MARK: - Extension -
//
//**********************************************************************************************************

extension Timer {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Internal Methods
    //**************************************************
    
    class func schedule(repeatInterval interval: TimeInterval, handler: ((Timer?) -> Void)!) -> Timer! {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, .commonModes)
        return timer
    }
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************
    
}
