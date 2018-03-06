# Keychain

![LOGO](Documentation/component_logo.png)


![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/v/AKKeychain)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/l/AKKeychain)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/p/AKKeychain)
[![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/i/AKKeychain)](./LICENSE)


# Description

**Keychain** provides a Swift wrapper for reading, writing and deleting a dictionary from iOS Keychain:

* Saving a dictionary to the keychain.
* Loading a previously saved dictionary from the keychain.
* Updating a dictionary into  keychain.
* Deleting all key:value pairs from the keychain that are associated with a given userAccount.
* Keychain sharing between apps.

For more information:


# Installation

#### CocoaPods:

[CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is a dependency manager for Cocoa projects. You can get more information about how to use it on [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Once you ready with CocoaPods, use this code in your `Podfile`:

```
source 'git@INMBZP4112.in.dst.ibm.com:apple-coc-frameworks-private/cocoapod-specs.git'

platform :ios, '9.0'
use_frameworks!

pod 'AKKeychain'
```

# Requirements

Version | Language | Xcode | iOS
------- | -------- | ----- | ---
1.5.0 | Swift 3.0 | 8.0 | 10.0


# Programming Guide

**Keychain property currently does not work on iOS 10 / Xcode 8. To make it work please enable Keychain Sharing in Capabilities tab.**

This section intends to give an overview about this component and its usage. Not all features included in this component will be covered here. This section will be focused on:

* Saving data to Keychain
* Loading data from Keychain
* Updating data from Keychain

We will not cover:

* Deleting data from Keychain

For more information, please check the API Documentation: [http://connection.com](http://connection.com)

### Saving data to the Keychain

You can save data without the options value in Keychain, like a generic password.

```
do{
try Keychain.saveData(["username":"MarkD", "password":"1234"], forUserAccount: "mobilefirst.AKKeychainTests", withOptions: options)

print("Saved data.")

}catch{

print("Error: \(error)")

}
```

### Loading data from the Keychain

This method can load data correspondent the user account passed in param.

```
do{
let storedCredentials = try Keychain.loadDataForUserAccount("mobilefirst.AKKeychainTests")

let data:[String: NSCoding!] = storedCredentials!

if (!data.isEmpty){
print("Load data")
}             
}catch{

print("Error: \(error)")

}

```
### Updating data from the Keychain
This method updates the values stored in the keychain, you need to enter the keys and values that need updating.

```
do{
try Keychain.updateData(["username":"MarkD", "password":"1234"], withAttributesToUpdate: ["username":"Mobile", "password":"5432"], forUserAccount: "mobilefirst.AKKeychainTests")

print("Update data")

}catch{

print("Error: \(error)")

}
```

### Additional Security Features (Security Access Control)
Security Access Control lets the developer decide whether the stored keychain access of TouchID can be shared between devices via iCloud or it's specific to the current device alone. This feature has been included as a part of KeychainOptions.

If developer does not pass a security option, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly is defaulted internally.

```
let optionObject = KeychainOptions()
optionObject.securityAccessType = SecurityAccessType.whenPasscodeSetThisDeviceOnly

```

### Keychain sharing between apps
How to share Keychain between iOS apps? 

You need to do following settings in your Xcode project - 

1. Under Xcode capabilities tab -> turn on keychain sharing option.
2. Under Xcode capabilities tab -> specify keychain group name:
3. Open entitlements file and append App ID Prefix to keychain group name.

Load shared keychain data - 

```
do {
let options = KeychainOptions()
options.group = "Group_Name"
let storedCredentials = try Keychain.loadSharedDataForUserAccount("mobilefirst.AKKeychainTests")

let data:[String: NSCoding!] = storedCredentials!

if (!data.isEmpty){
print("Load data")
}             
}catch{

print("Error: \(error)")

}

```


# FAQ

> How to integrate with the latest Swift beta-compatible version?

- To integrate with the latest Swift beta-compatible version, update your `Podfile` as follows:

```
pod 'AKKeychain', :git => 'git@INMBZP4112.in.dst.ibm.com:assemblykit/framework_akkeychain.git', :branch => 'swift3.0_gm_seed'
```

# Communication

Contact the developer's team:
[assemblykit@us.ibm.com](mailto:assemblykit@us.ibm.com)
