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
// MARK: - Class - LoginTextField
//
//**********************************************************************************************************

/**
The LoginTextField provides a custom UITextField that can be seen your layout in Interface Builder, because
this class has the attribute IBDesignable.
*/
@IBDesignable class LoginTextField: UITextField {

//**************************************************
// MARK: - Properties
//**************************************************

    /**
    This properties represent the insets of the LoginTextField, see the image below:
    ```
                    -
                    |
                    -
            ------ TOP -------
           |                  |
     |--| LEFT              RIGHT |--|
           |                  |
            ----- BOTTOM -----
                    -
                    |
                    -
    ```
    */
    var paddingTop: CGFloat = 10
    var paddingBottom: CGFloat = 10
    var paddingLeft: CGFloat = 10

    @IBInspectable
    var paddingRight: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
        
    }

//**************************************************
// MARK: - Constructors
//**************************************************

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

//**************************************************
// MARK: - Private Methods
//**************************************************

//**************************************************
// MARK: - Internal Methods
//**************************************************

    override func prepareForInterfaceBuilder() {
        initialize()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: self.paddingTop, left: self.paddingLeft, bottom: self.paddingBottom,
                                   right: self.paddingRight)
        let edges = UIEdgeInsetsInsetRect(bounds, padding)
        return super.textRect(forBounds: edges)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: self.paddingTop, left: self.paddingLeft, bottom: self.paddingBottom,
                                   right: self.paddingRight)
        let edges = UIEdgeInsetsInsetRect(bounds, padding)
        return super.editingRect(forBounds: edges)
    }

    func initialize() {
        self.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.layer.cornerRadius = 5.59
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0).cgColor
    }

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
