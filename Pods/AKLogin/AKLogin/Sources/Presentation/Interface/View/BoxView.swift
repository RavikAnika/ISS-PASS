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
import QuartzCore

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
BoxView is a IBDesignable class for custom view and used to box form.
*/
@IBDesignable class BoxView: UIView {

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
// MARK: - Properties
//**************************************************

    @IBInspectable
    var corner: CGFloat {

        set {
            self.layer.cornerRadius = newValue
        }

        get {
            return self.layer.cornerRadius
        }
        
    }

    @IBInspectable
    var borderSize: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }

        get {
            return self.layer.borderWidth
        }

    }

    @IBInspectable
    var borderColor: UIColor {

        set {
            self.layer.borderColor = newValue.cgColor
        }

        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        
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
        self.corner = 15.0
        self.borderSize = 4.0
        self.borderColor = UIColor(white: 150/255, alpha: 0.12)
    }

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
