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

@objc protocol ForgotPasswordProtocol {

    /**
     Tell the delegate when user taps the send button.

     - parameter identifier: String value and used to identifier the user.
     */
    @objc optional func forgotPasswordWithIdentifier(_ identifier: String)
}

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
The ForgotPasswordViewController class provides a screen like a UIAlertController with one field that app
will use to identifier user and recover the password.
*/
open class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

//**************************************************
// MARK: - Properties
//**************************************************

    internal weak var delegate: ForgotPasswordProtocol?

    @IBOutlet weak var forgotTextField: UITextField!

//**************************************************
// MARK: - Private Methods
//**************************************************

    fileprivate func configNotifications() {
        let notifCtr = NotificationCenter.default

        #if swift(>=2.2)
            notifCtr.addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow,
                                 object: nil)
            notifCtr.addObserver(self, selector: #selector(ForgotPasswordViewController.keyboardDismissed), name: NSNotification.Name.UIKeyboardWillHide,
                                 object: nil)
        #else
            notifCtr.addObserver(self, selector: "keyboardShow", name: UIKeyboardWillShowNotification,
                object: nil)
            notifCtr.addObserver(self, selector: "keyboardDismissed", name: UIKeyboardWillHideNotification,
                object: nil)
        #endif
    }

    fileprivate func requestAccess(_ identifier: String) {
        self.view.endEditing(true)
        if identifier.isEmpty == false {
            if let forgotDelegate = self.delegate {
                forgotDelegate.forgotPasswordWithIdentifier?(identifier)
            }
            
            self.dismissScreen()
        }
        
    }

//**************************************************
// MARK: - Internal Methods
//**************************************************

    func keyboardShow() {
        self.view.animateViewToNewYPosition(-70)
    }

    func keyboardDismissed() {
        self.view.animateViewToNewYPosition(0.0)
    }

    func dismissScreen() {
        self.dismiss(animated: true, completion: nil)
    }

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//*************************
// UITextFieldDelegate
//*************************

    /**
    Implemented protocol of UITextFieldDelegate.

    - parameter textField: TextField component that received the return action button.
    
    - returns: true if the text field should implement its default behavior for the return button; otherwise, false.
    
    - seealso: UITextFieldDelegate
    */
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.requestAccess(textField.text!)
        return true
    }

//*************************
// IBActions
//*************************

    /**
    Cancel action when user tap the button and need to back Login screen.
    
    - parameter sender: Object that received the action.
    */
    @IBAction open func tapCancel(_ sender: AnyObject) {
        self.dismissScreen()
    }

    /**
    Whe user tapped on the screen.
    
    - parameter sender: TapGesture object.
    */
    @IBAction open func tapGestureToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    /**
    When user put your identifier and request a password.
    
    - parameter sender: Object that received the action.
    */
    @IBAction open func tapSendUserIdentifier(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if self.forgotTextField == nil {
            
            self.requestAccess("Type your password here")
            
        } else {
            
            self.requestAccess(self.forgotTextField.text!)
            
        }
    
    }

//**************************************************
// MARK: - Override Public Methods
//**************************************************

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configNotifications()
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

}
