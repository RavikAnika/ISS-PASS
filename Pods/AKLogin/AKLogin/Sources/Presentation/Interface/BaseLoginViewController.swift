/*
 * Assembly Kit
 * Licensed Materials - Property of IBM
 * Copyright (C) 2016 IBM Corp. All Rights Reserved.
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
import LocalAuthentication
import AKKeychain

//**********************************************************************************************************
//
// MARK: - Constants -
//
//**********************************************************************************************************

let kKeychainAccount = "AKLogin.username"

//**********************************************************************************************************
//
// MARK: - Definitions -
//
//**********************************************************************************************************

/**
 The method declared by LoginViewControllerDelegate protocol need to delegate to responde to messasages from
 LoginViewController class, such as login with user name and password, and login with Touch ID.
 */
@objc public protocol LoginDelegate {

    /**
     Tells the delegate when user taps the sing in button.
     
     - parameter loginViewController: Object of type LoginViewController that used for login screen.
     - parameter username: Value that users input in user name field.
     - parameter password: Value that users input in password field. This values is not encrypt.
     - parameter completionHandler: Closure that be called when the finished validation. This closure has
     one parameter with type Bool and represent if login was the success.
     */
    func login(_ viewController: UIViewController, didLoginWithUsername username: String,
               password: String, completionHandler: @escaping (Bool) -> Void)

    /**
     Invoked when user taps the Forgot Password button.
     
     - parameter loginViewController: Object of type LoginViewController that used for login screen.
     - parameter username: String value and used to identifier the user.
     */
    @objc optional func login(_ viewController: UIViewController,
                              didForgotPasswordWithUser username: String, completionHandler: @escaping (Void) -> Void)

    /**
     Invoked when user signs in with Touch ID.
     
     - parameter loginViewController: Recevei the current LoginViewController.
     - parameter completionHandler: Closure that be called when the finished validation. This closure has
     one parameter with type Bool and represent if login was the success.
     */
    @objc optional func login(_ viewController: UIViewController,
                              didLoginUsingTouchWithCompletionHandler completionHandler: @escaping (Bool) -> Void)

}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
 Base class to login screen.
 */
open class BaseLoginViewController: UIViewController {

    //**************************************************
    // MARK: - Properties
    //**************************************************

    /**
     The user name field. In the Interface Builder your type is LoginTextField because the class used the
     attribute IBDesignable for change the layout.
     
     - seealso: LoginTextField
     */
    @IBOutlet open var usernameField: UITextField!

    /**
     The password field. In the Interface Builder your type is LoginTextField because the class used the
     attribute IBDesignable for change the layout.
     
     - seealso: LoginTextField
     */
    @IBOutlet open var passwordField: UITextField!

    /**
     The sing button is used in the Interface Builder with type LoginButton. If you need to change the
     background color or text color of the sign button, you will use the properties
     ``signInButtonBackgroundColor`` and ``signInButtonTextColor``.
     
     - important: Not create a new Action for this button.
     */
    @IBOutlet open var signInButton: UIButton!

    /**
     The delegate of LoginViewController. The delegate adopt the LoginViewControllerDelegate protocol.
     
     - seealso: LoginViewControllerDelegate
     */
    open weak var delegate: LoginDelegate?

    /**
     Requires password input.
     */
    open var passwordRequired: Bool = true

    /**
     Enable Touch ID for login.
     */
    open var enableTouchID: Bool = false

    /**
     This property defines if the username should be saved in Keychain.
     The last username with a login success will appear filled up at the next time.
     */
    internal var saveUsername: Bool = false

    /**
     Change property for username field.
     */
    open var defaultUserID: String? {
        didSet {
            self.usernameField?.text = defaultUserID
        }
        
    }

    /**
     Only has effect if username is populated. Change property for password field.
     */
    open var defaultPassword: String? {
        didSet {
            self.passwordField?.text = defaultPassword
        }
        
    }

    //**************************************************
    // MARK: - Constructors
    //**************************************************

    //**************************************************
    // MARK: - Private Methods
    //**************************************************

    private func loadLocalisedString() {
        self.usernameField.placeholder = NSLocalizedString("User name", bundle: Bundle(for: type(of: self)), comment: "User name")
        self.passwordField.placeholder = NSLocalizedString("Password", bundle: Bundle(for: type(of: self)), comment: "Password")
    }
    
    //*************************
    // Touch ID
    //*************************

    open func authorizeUsingTouchID() {
        if enableTouchID {
            //Disable Textfields
            DispatchQueue.main.async {
                self.enabledInterface(false)

                MultiFactorAuthentication.authenticate { (success, error) -> Void in
                    if success {
                        DispatchQueue.main.async {
                            // required credentials have been retrieved
                            self.delegate?.login?(self, didLoginUsingTouchWithCompletionHandler: {
                                (_) -> Void in
                                self.enabledInterface(true)
                            })
                        }
                        
                    } else {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.enabledInterface(true)
                            self.errorTouchID(error)
                        })
                    }
                    
                }

            }
            
        }
        
    }

    //**************************************************
    // MARK: - Internal Methods
    //**************************************************

    func validateCredentialsEntered() -> Bool {
        let username: String = (self.usernameField != nil) ?  self.usernameField.text! : ""
        let password: String = ( self.passwordField != nil) ?  self.passwordField.text! : ""

        if !self.passwordRequired {
            return !username.isEmpty
        } else {
            return !username.isEmpty && !password.isEmpty
        }
        
    }

    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************

    /**
     Enabled or disabled the UI components.
     
     - parameter enabled: Bool that determine if UI will is enabled or disabled.
     */
    open func enabledInterface(_ enabled: Bool, spinner: Bool = false) {
        self.signInButton?.isEnabled = enabled
        self.usernameField?.isEnabled = enabled
        self.passwordField?.isEnabled = enabled
    }

    /**
     Called when TouchID failed with authentication.
     
     - parameter error: An optional NSError that maybe has the information about the error with
     authentication.
     
     - seealso: LAError
     */
    open func errorTouchID(_ error: MFAError?) {
        if let codeError = error {

            if codeError != MFAError.userCancel && codeError != MFAError.userFallback {
                let alertController = UIAlertController(title: "", message: "",
                                                        preferredStyle: UIAlertControllerStyle.alert)
                alertController.title = NSLocalizedString("Unsuccessful", bundle: kFrameworkBundle,
                                                          comment: "Unsuccessful")
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK",
                                                                                 bundle: kFrameworkBundle, comment: "OK"), style: UIAlertActionStyle.cancel,
                                                                                                                           handler: nil))

                alertController.message = NSLocalizedString(codeError.description, comment:
                    codeError.description)
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("user cancelled")
            }

        }

    }

    //*************************
    // IBActions
    //*************************

    @IBAction open func signInPressed() {

        self.enabledInterface(false)

        // hide keyboard
        self.usernameField.resignFirstResponder()
        self.passwordField.resignFirstResponder()

        // make sure both credentials are entered

        if !self.validateCredentialsEntered() {
            // the required credentials were not entered
            self.enabledInterface(true)

            let alertController = UIAlertController(title: "", message: self.passwordRequired ?
                kAlertLoginUsernamePasswordErrorMSG : kAlertLoginUsernameErrorMSG,
                                                    preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: kAlertButtonOK,
                                                    style: UIAlertActionStyle.default, handler: nil))
            present(alertController, animated: true, completion: nil)

        } else {
            // required credentials have been entered (but not authenticated remotely yet)
            self.delegate?.login(self, didLoginWithUsername: self.usernameField.text!,
                                 password: passwordField.text!, completionHandler: { (_) -> Void in

                                    self.enabledInterface(true)
                                    if self.saveUsername {
                                        var _ = Keychain.saveData(["username": self.usernameField.text! as NSCoding],
                                                                  forUserAccount: kKeychainAccount)
                                    } else {
                                        
                                        do {
                                            var _ = try Keychain.deleteDataForUserAccount(kKeychainAccount)
                                        } catch {
                                            
                                        }
                                        
                                    }
                                    
            })
            
        }
        
    }

    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

    }

    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
