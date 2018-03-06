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
 Subclass of Logger class that logs information into a file. The file will be written into the documents
 directory and will be called output.txt
 */

extension String {
    
    func stringByRemovingAll(subStrings: [String]) -> String {
        var resultString = self
        _  = subStrings.map {
            resultString = resultString.replacingOccurrences(of: $0, with: "")
        }
        
        return resultString
    }
    
}

open class LoggerFile: Logger {
    
    //**************************************************
    // MARK: - Properties
    //**************************************************
    
    let dateFormatter: DateFormatter
    let defaultLoggerFolder = "Logs"
    
    open var defaultPrefixFilename = "AKLogger_"
    open var defaultPrefixExtension = ".log"
    open var maxFileSize: Int = 3 //in Megabytes.
    open var maxFileCounter: Int = 10
    var filePath: String?
    var fileNames: [String]?
    var fileContent: [String]?
    
    var structRollingFileLog = (fileArray: [Int: String](), currentFilePosition: -1)
    
    var timeStampString: String {
        
        let utc: TimeInterval = Date().timeIntervalSince1970 * 1000
        return utc.description.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
    }
    
    //**************************************************
    // MARK: - Constructors
    //**************************************************
    
    /**
     Initializes a LoggerFile with a default NSDateFormatter.
     The default date formatter uses NSDateFormatterStyle.ShortStyle for `dateStyle` and
     NSDateFormatterStyle.ShortStyle for `timeStyle`.
     */
    
    public override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = .short
        
        super.init()
        
        self.initMainLogDirectory()
        _ = self.addLogFileInStack()
    }
    
    //**************************************************
    // MARK: - Internal Methods
    //**************************************************
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return (documentsDirectory as NSString)
    }
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************
    
    /**
     Create a new sequential file based on the prefix setting concatenated with the TimeStamp.
     
     - parameter fileNamePrefix: fileNamePrefix: Sample = MyLogger_Tests_Debug.......
     
     - returns: Full name of the logger file, including the prefix more timestamp.
     */
    fileprivate func createRollingFileLogger(_ fileNamePrefix: String) -> String {
        
        var newFileNameLog: String = ""
        
        if !fileNamePrefix.isEmpty {
            
            newFileNameLog = fileNamePrefix
        }
        
        newFileNameLog += timeStampString + defaultPrefixExtension
        
        return newFileNameLog
    }
    
    /**
     Initializes the directory where the log files will be kept.
     
     - returns:
     */
    private func initMainLogDirectory() {
        
        var isDir = ObjCBool(true)
        
        #if swift(>=2.2)
            let pathLog = self.getFileLoggerPath() as String
            //self.getFileLoggerPath() as String
        #else
            let pathLog = self.getFileLoggerPath() as String
        #endif
        
        if !FileManager.default.fileExists(atPath: pathLog, isDirectory: &isDir) {
            
            do {
                
                try FileManager.default.createDirectory(atPath: pathLog, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("Error: \(error)")
            }
            
        }
        
    }
    
    /**
     Get the full path of the directory based logger.
     
     - returns: Full path of the directory based logger.
     */
    internal func getFileLoggerPath() -> NSString {
        return (self.getDocumentsDirectory() as String + "/" + defaultLoggerFolder + "/") as NSString
        
    }
    
    /**
     Returns the current logger file on the stack that is being processed.
     
     - returns: Current logger file on the stack that is being processed
     */
    fileprivate func getCurrentRollingFileLogger() -> String {
        
        var currentRollingFile: String = ""
        
        if self.structRollingFileLog.fileArray[self.structRollingFileLog.currentFilePosition] == nil
            || self.structRollingFileLog.fileArray[self.structRollingFileLog.currentFilePosition] == "" {
            currentRollingFile = self.addLogFileInStack()
        } else {
            currentRollingFile = self.structRollingFileLog.fileArray[self.structRollingFileLog.currentFilePosition]!
        }
        
        return currentRollingFile
    }
    
    /**
     It includes a new fragmented file in the rolling stack files.
     
     - returns: The file name of this current position.
     */
    fileprivate func addLogFileInStack() -> String {
        
        let newFileLog = createRollingFileLogger(self.defaultPrefixFilename)
        
        #if swift(>=2.2)
            self.structRollingFileLog.currentFilePosition += 1
        #else
            ++self.structRollingFileLog.currentFilePosition
        #endif
        
        if self.structRollingFileLog.fileArray.count >= self.maxFileCounter
            || self.structRollingFileLog.currentFilePosition > self.maxFileCounter
            || self.structRollingFileLog.currentFilePosition < 0 {
            
            self.structRollingFileLog.currentFilePosition = 0
            
            let fileName = fethcMostLRUFile()
            self.deleteLogFile(name: defaultPrefixFilename+fileName+defaultPrefixExtension)
            
        }
        
        self.structRollingFileLog.fileArray[self.structRollingFileLog.currentFilePosition] =
            self.structRollingFileLog.fileArray[self.structRollingFileLog.currentFilePosition] ?? newFileLog
        
        if getFileList().count >= self.maxFileCounter {
            let fileName = fethcMostLRUFile()
            self.deleteLogFile(name: defaultPrefixFilename+fileName+defaultPrefixExtension)
        }
        
        return self.structRollingFileLog.fileArray[self.structRollingFileLog.currentFilePosition]!
    }
    
    fileprivate func fethcMostLRUFile() -> String {
        
        var lruFileName = ""
        let files = self.getFileList()
        
        var timestamps = [Int] ()
        for file in files {
            if file.contains(defaultPrefixFilename) {
                let substring = [defaultPrefixFilename, defaultPrefixExtension]
                let timestampString = file.stringByRemovingAll(subStrings:substring)
                timestamps.append(Int(timestampString)!)
            }
            
        }
        
        let sortedArray = timestamps.sorted()
        lruFileName = String(sortedArray[0])
        return lruFileName
    }
    
    /**
     Validates in writing time if the file is with the full size in megabytes. If it is full, it will be created a new starting the last.
     
     - parameter currentFileLog: Receives the current file logger.
     
     - returns: Returns true if the current file is full, as defined in the variable [MAXFILESIZE]
     */
    fileprivate func validRollingFileSizeIsFull(_ currentFileLog: String) -> Bool {
        
        let filePath = currentFileLog
        var fileSize: UInt64 = 0
        var resultCheckFileSize = false
        
        do {
            let attr: NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary?
            
            if let _attr = attr {
                fileSize = _attr.fileSize()
                
                #if swift(>=2.2)
                    let actualSize: UInt64 = fileSize / 1024
                #else
                    var actualSize: UInt64 = fileSize / 1024
                #endif
                
                print(actualSize)
                
                if Int(actualSize) >= self.maxFileSize * 1000 {
                    
                    // If the size the size in KB overcome, append a new file and set the cursor.
                    resultCheckFileSize = true
                }
                
            }
            
        } catch {
            resultCheckFileSize = false
        }
        
        return resultCheckFileSize
    }
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    /**
     Reads the log file and returns an array containing every log entry.
     
     - returns: String array containing every log entry.
     */
    open func log() -> [String] {
        
        let path = self.getFileLoggerPath()
        filePath = path as String!
        let file = path.appendingPathComponent(self.getCurrentRollingFileLogger())
        var logMessages = [String]()
        
        if let str = try? String(contentsOfFile: file as String) {
            
            let lines = str.components(separatedBy: CharacterSet.newlines)
            for line in lines {
                logMessages.append(line)
            }
            
            // element after last new line does not represent any content
            logMessages.removeLast()
        }
        
        return logMessages
    }
    
    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************
    
    /**
     Logs the message into into a file. The file will be written into the documents directory and will be
     called output.txt
     
     - parameter message: The message to be logged into the file
     - parameter logLevel: The log level information will be prepended into the message before the message
     is saved.
     */
    override open func logMessage(_ message: String, logLevel: LogLevel) {
        if !(logLevel.rawValue >= self.logLevel.rawValue) {
            return
        }
        
        let date = Date()
        let dateStr = dateFormatter.string(from: date)
        
        let str = "[\(dateStr)] - [\(logLevel.toString())] - \(message)" + "\n"
        let data = str.data(using: String.Encoding.utf8)!
        
        var path = self.getFileLoggerPath().appendingPathComponent(self.getCurrentRollingFileLogger())
        
        // Checks if Rolling File Log is Full.
        if validRollingFileSizeIsFull(path) {
            
            _ = self.addLogFileInStack()
            
            // Capture the new file fragment.
            path = self.getFileLoggerPath().appendingPathComponent(self.getCurrentRollingFileLogger())
        }
        
        let pathURL = URL(string: path)
        
        guard let fileHandle = try? FileHandle(forWritingTo: pathURL!) else {
            FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            return
        }
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
    
}
