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

// DBG_LVL controls level of output. Default is level 1.

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

let kDebugLevel: Int = 1
let kDebugInfo: Int = 2
let kDebugWarining: Int = 3
let kDebugError: Int = 4
let kDebugVerbose: Bool = true

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

//**************************************************
// MARK: - Internal Methods
//**************************************************

#if DEBUG

    #if swift(>=2.2)
        func log(message: String, level: Int = 1, file: String = #file, method: String = #function, line: Int = #line) {
            if level<=kDebugLevel {
                if kDebugVerbose {
                    print("[\(level)]\((file as NSString).lastPathComponent):\(method) line:\(line)\t\tmessage:\(message)", terminator: "")
                } else {
                    print("\(message)", terminator: "")
                }
                
            }
            
        }
        
    #else
        func log(message: String, level: Int = 1, file: String = __FILE__, method: String = __FUNCTION__, line: Int = __LINE__) {
            if level<=DBG_LVL {
                if DBG_VERBOSE {
                print("[\(level)]\((file as NSString).lastPathComponent):\(method) line:\(line)\t\tmessage:\(message)", terminator: "")
                } else {
                    print("\(message)", terminator: "")
                }
        
            }
        
        }
        
    #endif

#else

    #if swift(>=2.2)
    func log(_ message: String, level: Int = 1, file: String = #file, method: String = #function, line: Int = #line) {

        }
        
    #else
    func log(message: String, level: Int = 1, file: String = __FILE__, method: String = __FUNCTION__,
        line: Int = __LINE__) {

    }
        
#endif

#endif
