/*
 * Assembly Kit
 * Licensed Materials - Property of IBM
 * Copyright (C) 2017 IBM Corp. All Rights Reserved.
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
// MARK: - Extension for File opreations (Read and Delete) -
//
//**********************************************************************************************************

extension LoggerFile {
    
    open func getFileList() -> [String] {
        let filemanager: FileManager = FileManager()
        do {
            if filePath == nil {
                filePath = self.getFileLoggerPath() as String
            }
            
            if fileNames == nil {
                fileNames = [String]()
            }
            
            let filesInDirectory =  try filemanager.contentsOfDirectory(atPath: filePath!) as [String]
            for file in filesInDirectory {
                if fileNames?.contains(file) == false {
                    fileNames?.append(file)
                }
                
            }
            
        } catch {
        }
        
        return fileNames!
    }
    
    open func getFileContent() -> [String] {
        fileContent = [String]()
        if let files = fileNames {
            for file in files {
                if let path = filePath {
                    let path = path.appending(file)
                    do {
                        let contentsOfFile = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                        fileContent?.append(contentsOfFile)
                    } catch {
                    }
                    
                }
                
            }
            
        }
        
        return (fileContent)!
    }
    
    /**
     Delete all files excepts most recents, as defined into maxFileCounter
     
     - throws: This operation can fail and must be treated with try/catch.
     */
    open func purgeLogFiles() throws {
        
        // Delete all files excepts N most recents conforms sets on variable [maxFileCounter].
    }
    
    open func deleteLogFile(name: String) {
        var fileName = name
        do {
            if !name.contains(defaultPrefixExtension) {
                fileName = name + defaultPrefixExtension
            }
            
            let fileManager = FileManager.default
            
            #if swift(>=2.2)
                let folderLogger = self.getFileLoggerPath() as String
            #else
                let folderLogger = self.getFileLoggerPath() as String
            #endif
            
            let filePath = folderLogger + fileName
            
            try fileManager.removeItem(atPath: filePath)
            
            fileNames?.removeAll()
            fileContent?.removeAll()
            
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
    }
    
    /**
     To delete all log files into default directory.
     
     - throws: <#throws value description#>
     */
    open func deleteAllLogs() throws {
        
        // Delete all Logger Files.
        do {
            
            let fileManager = FileManager.default
            
            #if swift(>=2.2)
                let folderLogger = self.getFileLoggerPath() as String
            #else
                let folderLogger = self.getFileLoggerPath() as String
            #endif
            
            let listFiles = try fileManager.contentsOfDirectory(atPath: folderLogger)
            
            for fileItem in listFiles {
                
                let logname = folderLogger + fileItem
                try fileManager.removeItem(atPath: logname)
            }
            
            fileNames?.removeAll()
            fileContent?.removeAll()
            
        } catch let error as NSError {
            print("Error: \(error)")
        }
        
    }

}
