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

//**********************************************************************************************************
//
// MARK: - Class -
//
//**********************************************************************************************************

/**
The LoginButton provides a custom UIButton that can be seen your layout directly in Interface Builder, 
because this class has the attribute IBDesignable.
*/
@IBDesignable class LoginButton: UIButton {

//**************************************************
// MARK: - Properties
//**************************************************

    @IBInspectable
    var borderColor: UIColor = UIColor(red: 36/255, green: 59/255, blue: 83/255, alpha: 1.0) {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
        
    }

    @IBInspectable
    var fillColor: UIColor = UIColor(red: 36/255, green: 59/255, blue: 83/255, alpha: 1.0) {
        didSet {
            self.backgroundColor = self.fillColor
        }
        
    }

    @IBInspectable
    var cornerRadius: CGFloat = 20.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
        
    }

    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
        
    }

//**************************************************
// MARK: - Constructors
//**************************************************

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }

//**************************************************
// MARK: - Private Methods
//**************************************************

//**************************************************
// MARK: - Internal Methods
//**************************************************

    override func prepareForInterfaceBuilder() {
        self.initialize()
    }

    func initialize() {
        self.layer.borderWidth = self.borderWidth
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderColor = self.borderColor.cgColor
        self.backgroundColor = self.fillColor
    }

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
