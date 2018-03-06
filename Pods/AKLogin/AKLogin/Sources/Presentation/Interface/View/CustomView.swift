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

import UIKit

extension UIView {

//**************************************************
// MARK: - Constructors
//**************************************************

//**************************************************
// MARK: - Properties
//**************************************************

//**************************************************
// MARK: - Private Methods
//**************************************************

//**************************************************
// MARK: - Internal Methods
//**************************************************

    internal func animateViewToNewYPosition(_ newYPosition: CGFloat) {
        if self.frame.origin.y == newYPosition {
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = newYPosition
            }, completion: nil)
    }

//**************************************************
// MARK: - Self Public Methods
//**************************************************

//**************************************************
// MARK: - Override Public Methods
//**************************************************

}
