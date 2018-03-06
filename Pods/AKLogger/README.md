# Logger

![LOGO](Documentation/component_logo.png)


![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/v/AKLogger)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/l/AKLogger)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/p/AKLogger)
[![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/i/AKLogger)](./LICENSE)


# Description

**Logger** is a framework for managing the logging process of an application. It provides an easy way for working with multiple log levels, log to different destinations such as the console, file or system log.

**Features**

* Log Level
* Console log
* File log
* Apple System Log

# Installation

#### CocoaPods:

[CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is a dependency manager for Cocoa projects. You can get more information about how to use it on [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Once you ready with CocoaPods, use this code in your `Podfile`:

```
source 'git@INMBZP4112.in.dst.ibm.com:apple-coc-frameworks-private/cocoapod-specs.git'

platform :ios, '9.0'
use_frameworks!

pod 'AKLogger', '~> 1.0.0'
```

# Requirements

Version | Language | Xcode | iOS
------- | -------- | ----- | ---
1.5.0 | Swift 3.0 | 8.0 | 10.0


# Programming Guide
This section intends to give an overview about this component and its usage. Not all features included in this component will be covered here. The focus of this section will be:

* Initialization
* Log Level

#### Initialization
Start by importing the package in the file you want to use it.

```
import AKLogger
```

The next step is to instantiate and add any Logger object to the Logger system. The available Logger objects are:

* LoggerConsole
* LoggerFile
* LoggerASL

```
let fileLogger = LoggerFile()

// configure fileLogger
fileLogger.logLevel = LogLevel.warning

AKLogger.addLogger(fileLogger)
```

This should be made on an entry point of the application such as AppDelegate and just need to be done once.

#### Log Level

After adding all the wanted loggers, use the log methods to log with the desired level:

* AKLogInfo: logs info for loggers with logLevel less than or equal to LogLevel.info
* AKLogWarn: logs info for loggers with logLevel less than or equal to LogLevel.warning
* AKLogDebug: logs info for loggers with logLevel less than or equal to LogLevel.debug
* AKLogError: logs info for loggers with logLevel less than or equal to LogLevel.error

```
let message = "Log message"
AKLogInfo(message)
```

# FAQ

> When should I initialize the framework?

- Basically It should be initialized before it is first used. Typcally it would be in the `applicationDidFinishLaunching` method of your AppDelegate.

> Is it possible to send the log data to a remote location?

- This feature is not yet available.


# Communication

Contact the developer's team:
[assemblykit@us.ibm.com](mailto:assemblykit@us.ibm.com)
