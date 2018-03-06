# Login  

![LOGO](Documentation/component_logo.png)


![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/v/AKLogin)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/l/AKLogin)
![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/p/AKLogin)
[![POD](http://assemblykitdev.w3ibm.mybluemix.net/shields/i/AKLogin)](./LICENSE)


# Description

**Login** creates a standard UI/UX implementation for authentication without implementing server connection. Login framework provides user interface for:

* Accepting login credentials (user name and password)
* Supporting TouchID (optional)
* Displaying app version number
* Saving token to use Single sign-on

The framework provides UI for:

* iPad (portrait and landscape)
* iPhone (portrait and landscape / all form factors)

This framework does not perform authentication with a server. Authentication will be handled elsewhere.

# Installation

#### CocoaPods:
[CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is a dependency manager for Cocoa projects. You can get more information about how to use it on [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Once you ready with CocoaPods, use this code in your `Podfile`:

```
source 'git@INMBZP4112.in.dst.ibm.com:apple-coc-frameworks-private/cocoapod-specs.git'

platform :ios, '9.0'
use_frameworks!

pod 'AKLogin'
```

# Requirements

Version | Language | Xcode | iOS
------- | -------- | ----- | ---
1.5.0 | Swift 3.0 | 8.0 | 10.0


# Programming Guide


## Initialization

You need import Login framework to use it.

```
import AKLogin
```

The LogIn screen is using a **LoginViewController** instance, this is
partially cutomizable screen. See below for an example:

![IMAGE](Documentation/iPhoneLoginScreen.png)

**Important:** the layout works with **defaultController()** function. 

```
let controller = LoginViewController.defaultController()

```
## Handling Login

When user taps the `Sign In` button, or successfully authenticates with Touch ID, login controller's delegate will be notified. It is up to the delegate to perform validation of supplied credentials and notify the login controller by calling the completion handler.


```
init() {
// create the login controller
let controller = LoginViewController.defaultController()

// set the delegate
controller.delegate = self

// style away
controller.headingText = "Login Rocks!"
controller.footerText = "v1.0.0"
}

func login(_ viewController: UIViewController, didLoginWithUsername username: String,
password: String, completionHandler: (Bool) -> Void) {

// perform some asynchronous authentication
// ...

// call the completion handler with result (true is success, false is failure)
completionHandler(true)
}

```

## Save Username

**Keychain property currently does not work on iOS 10 / Xcode 8. To make it work please enable Keychain Sharing in Capabilities tab.** 

For saving username to keychain, use the rememberMe feature in Login .User has to set rememberMeIsHidden property to false to show the remeberMe View.

```
controller.rememberMeIsHidden = false
```
Once user set the switch to on, username will be saved to keychain.


## Touch ID

If you want to use the Touch ID iOS feature with login, you need to change enableTouchID value, then use the authorizeUsingTouchID() method call, like example below:

```
controller.enableTouchID = true
controller.authorizeUsingTouchID()

```

## Single sign-on

If you want to use Single sign-on, you need save and load token on keychain, like example below:

### Save
```
controller.saveToken("TOKEN", expirationTime: NSDate())
```

### Load
```
if let token = controller.loadToken(){
// Your action
}
```

### Delete
```
controller.deleteToken()
```

## Styling

You can customize login screen across of the API, see below:

For form background color

```
controller.insetBackgroundColor = UIColor.blue
```

For background view color/ image

```
controller.backgroundViewColor = UIColor.white
controller.backgroundViewImage = nil
```

The logo default value is UIImage with name ibm. User can change the logo

```    
controller.logo = UIImage(named: "ibm_black")
```

Change property for Heading label text color value

```
controller.headingTextColor = UIColor.white
```

Change property for username & password field background color

```
controller.inputFieldBackgroundColor = UIColor.lightGrey
```

To make the remeberme field visible

```
controller.rememberMeIsHidden = false
```

To make the needHelp Label visible

```
controller.needHelpIsHidden = false
```

Change property for username & password field text color

```
controller.inputFieldTextColor = UIColor.lightGrey
```

Change property for Remember me Label Text color value

```
controller.rememberMeLabelTextColor = UIColor.white
```

Change property for Need help Label Text color value

```
controller.needHelpLabelTextColor = UIColor.white
```

Change property for Sign In button background color value

```
controller.signInButtonBackgroundColor = UIColor.blue
```

Change property for Spinner color

```
controller.spinnerColor = UIColor.white
```
# FAQ

> Does Login connect with API server?

- No! **Login** creates a standard UI/UX implementation.


# Communication

Contact the developer's team:
[assemblykit@us.ibm.com](mailto:assemblykit@us.ibm.com)
