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

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {

    //*************************
    // UITextFieldDelegate
    //*************************
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // hide previous keyboard
        textField.resignFirstResponder()
        
        // show next keyboard if necessary
        let nextTag = textField.tag + 1
        let nextResponder: UIResponder? = textField.superview!.viewWithTag(nextTag)
        if nextResponder != nil {
            nextResponder!.becomeFirstResponder()
        } else {
            // act as a sign in
            self.signInPressed()
        }
        
        return false
    }
    
    //**************************************************
    // MARK: - Self Public Methods
    //**************************************************
    
    func keyboardShown(notification: NSNotification) {
        
        animateViewToNewYPosition(self.view, newYPosition: viewOffsetForKeyboard)
    }
    
    func keyboardDismissed(notification: NSNotification) {
        
        animateViewToNewYPosition(self.view, newYPosition: 0)
    }
    
    func animateViewToNewYPosition(_ view: UIView, newYPosition: CGFloat) {
        
        if view.frame.origin.y == newYPosition {
            return
        }
        
        UIView.animate(withDuration: kKeyboardAnimationDuration, animations: {
            view.frame.origin.y = newYPosition
        }, completion: nil)
    }
    
    func configNotifications() {
        let notifCtr = NotificationCenter.default
        
        notifCtr.addObserver(self, selector: #selector(LoginViewController.keyboardShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow,
                             object: nil)
        notifCtr.addObserver(self, selector: #selector(LoginViewController.keyboardDismissed(notification:)), name: NSNotification.Name.UIKeyboardWillHide,
                             object: nil)
    }
    
    func loadRememberUser() {
        if self.rememberMeSwitch.isOn {
            saveUsername = true
            defaultValue.set(true, forKey: key)
        } else {
            saveUsername = false
            defaultValue.set(false, forKey: key)
        }
        
    }
    
    func colorFromHexString(_ hex: String, alpha: CGFloat) -> UIColor {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb & 0xFF00) >> 8)/255.0,
            blue: CGFloat((rgb & 0xFF) )/255.0,
            alpha: alpha)
    }
    
    @available(iOS, introduced: 8.0)
    open class func defaultController() -> LoginViewController {
        let frameworkStoryboard = UIStoryboard(name: "Login", bundle: Bundle(for: self))
        let name = "mobileFirstIdentifier"
        let login: LoginViewController? = frameworkStoryboard.instantiateViewController(withIdentifier: name)
            as? LoginViewController
        return login!
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
