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
import AKLogin
import AKNetworking

let KEYCHAIN_ACCT = Bundle.main.bundleIdentifier! + ".Login"

class AuthenticationController: UIViewController, LoginDelegate {
    /// The delegate of the authentication controller
    var delegate: AuthenticatonControllerDelegate = Authenticator()
    
    /// The `Authorization` HTTP header value
    var authorizationHeader: String? { return self.delegate.authenticationControllerAuthorizationHeader(self) }
    
    fileprivate var loginViewController: LoginViewController!
    fileprivate var securedRootViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add notification center observer to be alerted of any change to NSUserDefaults.
        NotificationCenter.default.registerForSettingsChangeNotificationsWithHandler {
            self.update()
        }
        
        self.loadAuthorizationController()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Sign out action
    
    func signOut() {
        // make sure secured root view controller exists
        guard let securedRootViewController = self.securedRootViewController else { return }
        
        // delegate to authenticator perform any sign out actions
        self.delegate.authenticationControllerDeauthorize(self)
        
        // transition back to login controller
        transitionFromViewController(securedRootViewController, toController: loginViewController, options: UIViewAnimationOptions())
        self.securedRootViewController = nil
        
        Pass.listofPasses = [Pass]()
        if let credentials = readStoredCredentialsFromKeychain() as? [ String : String ] {
            self.loginViewController.defaultUserID = credentials["username"]
            self.loginViewController.defaultPassword = credentials["password"]
            
            
        }
    }
    
    // MARK: - Private setup and management
    
    fileprivate func loadAuthorizationController() {
        // load the app name
        let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        
        // create the login controller
        self.loginViewController = LoginViewController.defaultController()
        self.loginViewController.delegate = self
        self.loginViewController.passwordRequired = false
        self.loginViewController.headingText = displayName
        
        // Check if there are any stored credentials
        // Enable touchID if there are (touchId will not work without stored credentials)
        self.loginViewController.enableTouchID = false
        if let _ = readStoredCredentialsFromKeychain() {
            self.loginViewController.enableTouchID = true
        }
        
        // for demo purpose
        self.loginViewController.defaultUserID = "Ravi K Anika"
        self.loginViewController.defaultPassword = "admin"
        
        // updates the footer text
        self.update()
        
        // add login as child view controller
        self.addChildViewController(loginViewController)
        view.addSubview(loginViewController.view)
        loginViewController.didMove(toParentViewController: self)
    }
    
    
    fileprivate func readStoredCredentialsFromKeychain() -> [String : NSCoding]? {
        
        return nil
    }
    
    
    // to controller is the split view controller
    fileprivate func transitionFromViewController(_ fromController: UIViewController, toController: UIViewController, options: UIViewAnimationOptions) {
        toController.view.frame = fromController.view.bounds
        self.addChildViewController(toController)
        fromController.willMove(toParentViewController: nil)
        
        self.view.addSubview(toController.view)
        
        UIView.transition(from: fromController.view, to: toController.view, duration: 0.2, options: options, completion: { (finished) -> Void in
            toController.didMove(toParentViewController: self)
            
            fromController.removeFromParentViewController()
            fromController.view.removeFromSuperview()
        })
    }
    
    
    func update() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let envMode = AppSettings.sharedInstance.localMode ? "(LOCAL)" : ""
        self.loginViewController.footerText = "\(appVersion) \(envMode)"
    }
    
    
    // MARK: - Login response handling
    
    fileprivate func loginSuccessful() {
        // create the root view controller
        let mainStoryboard = Bundle.main.infoDictionary?["UIMainStoryboardFile"] as! String
        self.securedRootViewController = UIStoryboard(name: mainStoryboard, bundle: nil).instantiateInitialViewController()!
        
        // perform any additional service request or just load the main view controller
        transitionFromViewController(self.loginViewController, toController: self.securedRootViewController, options: UIViewAnimationOptions.transitionCrossDissolve)
    }
    
    
    fileprivate func loginFailedWithError(_ error: NSError) {
        // create the error message
        var message: String
        if error.code == 401 {
            message = NSLocalizedString("Your username or password is incorrect.", comment: "Incorrect username/password")
        } else {
            message = NSLocalizedString("Network Error", comment: "Network Error")
        }
        
        // show the alert
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    
    // MARK: - Login delegate
    
    func login(_ viewController: UIViewController, didLoginWithUsername username: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        // start authentication
        self.delegate.authenticationController(self, authorizeWithUsername:username, password: password) { (error) -> Void in
            if let error = error {
                // inform login controller the login is unsuccessfully complete
                completionHandler(false)
                self.loginFailedWithError(error)
            } else {
                // inform login controller the login is successfully complete
                completionHandler(true)
                
                // enable TouchID (stored credentials make TouchID possible)
                self.loginViewController.enableTouchID = true
                
                self.loginSuccessful()
            }
        }
    }
    
    func login(_ viewController: UIViewController, didLoginUsingTouchWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        // retrieve the stored credentials from the keychain
        guard let storedCredentials = readStoredCredentialsFromKeychain(),
            let username = storedCredentials["username"] as? String,
            let password = storedCredentials["password"] as? String else {
                completionHandler(false)
                return
        }
        
        // start authentication
        self.delegate.authenticationController(self, authorizeWithUsername:username, password: password) { (error) -> Void in
            if let error = error {
                // inform login controller the login is unsuccessfully complete
                completionHandler(false)
                
                self.loginFailedWithError(error)
            } else {
                // inform login controller the login is successfully complete
                completionHandler(true)
                
                self.loginSuccessful()
            }
        }
    }
}
