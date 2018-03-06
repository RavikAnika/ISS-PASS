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

open class LoginViewController: BaseLoginViewController {

    //**************************************************
    // MARK: - Properties
    //**************************************************
    let kKeyboardAnimationDuration = 0.3
    let key = "rememberMe"
    let defaultValue = UserDefaults()
    
    @IBOutlet weak var footerLabel: UILabel!

    @IBOutlet weak var headingLabel: UILabel!

    @IBOutlet weak var interactionBlockView: UIView!
    @IBOutlet open weak var logoImageView: UIImageView!

    @IBOutlet weak var form: UIView!

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var backgroundView: UIImageView!

    @IBOutlet weak var rememberMeSwitch: UISwitch!

    @IBOutlet weak var rememberMeLabel: UILabel!

    @IBOutlet weak var needHelpLabel: UILabel!

    @IBOutlet weak var rememberMeView: UIView!
    
    open var viewOffsetForKeyboard: CGFloat = -170.0
    
    open var insetBackgroundColor: UIColor? = Colors.white {
        didSet {
            form?.backgroundColor = insetBackgroundColor
        }
        
     }

    open var backgroundViewColor: UIColor? = Colors.darkBlue {
        didSet {
            self.backgroundView.backgroundColor = backgroundViewColor
        }
        
    }

    open var backgroundViewImage: UIImage? = UIImage(named: "BGImage") {
        didSet {
            self.backgroundView.image = backgroundViewImage
        }
        
    }

    open var headerText: String? {
        didSet {
            self.headingLabel?.text = self.headerText
        }
        
    }

    open var logo: UIImage? = UIImage(named: "ibm", in: Bundle(for: LoginViewController.self),
        compatibleWith: nil) {
        didSet {
            self.logoImageView?.image = self.logo
        }
        
    }

    struct Colors {
        static let darkBlue = UIColor(red:0.28, green:0.74, blue:0.91, alpha:1.0)
        static let mediumBlue = UIColor(red:0.78, green:0.92, blue:0.97, alpha:1.0)
        static let lightBlue = UIColor(red:0.94, green:0.98, blue:0.99, alpha:1.0)
        static let darkGray = UIColor(red:0.33, green:0.35, blue:0.37, alpha:1.0)
        static let lightGray = UIColor(red:(239.0/255.0), green:(239.0/255.0), blue:(240.0/255.0), alpha:1.0)
        static let white = UIColor(red:1.0, green:1.0, blue:1.0, alpha:1.0)
    }

    open var formViewCornerRadius: CGFloat? = 0.0 {
        didSet {
            self.form?.layer.cornerRadius = formViewCornerRadius!
        }
        
    }
    
    /**
     Change property for username field.
     */
    open var defaultUserNamePlaceHolder: String = "User name"{
        didSet {
            self.usernameField?.placeholder = NSLocalizedString(defaultUserNamePlaceHolder, bundle: Bundle(for: type(of: self)), comment: defaultUserNamePlaceHolder)
        }
        
    }
    
    /**
     Change property for username field.
     */
    open var defaultPasswordPlaceHolder: String = "Password" {
        didSet {
            self.passwordField?.placeholder = NSLocalizedString(defaultPasswordPlaceHolder, bundle: Bundle(for: type(of: self)), comment: defaultPasswordPlaceHolder)
        }
        
    }
    
    open var loginButtonText: String = "Log in"{
        didSet {
            self.signInButton?.setTitle(NSLocalizedString(loginButtonText, bundle: Bundle(for: type(of: self)), comment: loginButtonText), for: UIControlState())
        }
    }

    /// change property for Heading label text value
    open var headingText: String? {
        didSet {
            self.headingLabel?.text = headingText
        }
        
    }

    /// change property for Heading label text color value
    open var headingTextColor: UIColor? = Colors.darkBlue {
        didSet {
            self.headingLabel?.textColor = headingTextColor
        }
        
    }

    /// the underlying attributed string drawn by the label, if set, the label ignores the properties above.
    open var attributedHeadingText: NSAttributedString? {
        didSet {
            self.headingLabel?.attributedText = attributedHeadingText
        }
        
    }

    /// change property for footer label text value
    open var footerText: String? {
        didSet {
            self.footerLabel?.text = footerText
        }
        
    }

    /// change property for footer label text color value
    open var footerTextColor: UIColor? = UIColor.white {
        didSet {
            self.footerLabel?.textColor = footerTextColor
        }
        
    }

    /// the underlying attributed string drawn by the label, if set, the label ignores the properties above.
    open var attributedFooterText: NSAttributedString? {
        didSet {
            self.footerLabel?.attributedText = attributedFooterText
        }
        
    }

    /// change property for input field background color
    open var inputFieldBackgroundColor: UIColor? = Colors.lightGray {
        didSet {
            usernameField?.backgroundColor = inputFieldBackgroundColor
            passwordField?.backgroundColor = inputFieldBackgroundColor
        }
        
    }

    /// make the remeberme field visible or invisible
    open var rememberMeIsHidden = true {
        didSet {
            rememberMeView.isHidden = rememberMeIsHidden
        }
        
    }

    /// make the needHelp field visible or invisible
    open var needHelpIsHidden = true {
        didSet {
            needHelpLabel.isHidden = needHelpIsHidden
        }
        
    }

    /// change property for input field text color
    open var inputFieldTextColor: UIColor? = Colors.darkGray {
        didSet {
            usernameField?.textColor = inputFieldTextColor
            passwordField?.textColor = inputFieldTextColor
        }
        
    }

    /// change property for Sign In button text color value
    open var signInButtonTextColor: UIColor? = UIColor.white {
        didSet {
            signInButton?.setTitleColor(signInButtonTextColor, for: UIControlState.normal)
            signInButton?.setTitleColor(signInButtonTextColor, for: UIControlState.selected)
        }
        
    }

    /// change property for Remember me Label background color value
    open var rememberMeLabelTextColor: UIColor? = UIColor.white {
        didSet {
            rememberMeLabel.textColor = rememberMeLabelTextColor
        }
        
    }

    /// change property for Need help Label background color value
    open var needHelpLabelTextColor: UIColor? = UIColor.white {
        didSet {
            needHelpLabel.textColor = needHelpLabelTextColor
        }
        
    }

    /// change property for Sign In button background color value
    open var signInButtonBackgroundColor: UIColor? = UIColor(red:0.42, green:0.79, blue:0.93, alpha:1.0) {
        didSet {
            signInButton?.backgroundColor = signInButtonBackgroundColor
        }
        
    }

    /// change property for Spinner color
    open var spinnerColor: UIColor? = Colors.darkGray {
        didSet {
            self.spinner?.color = spinnerColor
        }
        
    }
    
    //**************************************************
    // MARK: - Private Methods
    //**************************************************

    fileprivate func configLoginScreen() {
        setText()
        setColor()

        if let logo = self.logo {
            self.logoImageView.image = logo
        }

        if let updatedForm = self.form {
            self.form = updatedForm
        }

        if let formViewCornerRadius = self.formViewCornerRadius {
            self.form.layer.cornerRadius = formViewCornerRadius
        }

        self.rememberMeIsHidden = true
        self.needHelpIsHidden = true
        usernameField.borderStyle = UITextBorderStyle.none
        passwordField.borderStyle = UITextBorderStyle.none
        usernameField.layer.borderWidth = -2
        passwordField.layer.borderWidth = -2
        rememberMeSwitch.layer.cornerRadius = 16
        rememberMeSwitch.backgroundColor = Colors.white
        self.usernameField.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 17.0)
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.rememberMeSwitch.isOn = defaultValue.bool(forKey: key)
        rememberMeSwitch.addTarget(self, action: #selector(LoginViewController.loadRememberUser), for: UIControlEvents.valueChanged)
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        self.spinner.color = self.spinnerColor

    }
    
    func setText() {
        if let footerText = self.footerText {
            self.footerLabel.text = footerText
        }
        
        if let headerText = self.headerText {
            self.headingLabel.text = headerText
        }
        
        if let defaultUserID = self.defaultUserID {
            self.usernameField.text = defaultUserID
        }
        
        if let defaultPassword = self.defaultPassword {
            self.passwordField.text = defaultPassword
        }
        
        if let attributedHeading = self.attributedHeadingText {
            self.headingLabel.attributedText = attributedHeading
        }
        
        if let attributedFooter = self.attributedFooterText {
            self.footerLabel.attributedText = attributedFooter
        }
        
        self.signInButton?.setTitle(NSLocalizedString(self.loginButtonText, bundle: Bundle(for: type(of: self)), comment: self.loginButtonText), for: UIControlState())
        
        self.usernameField?.placeholder = NSLocalizedString(defaultUserNamePlaceHolder, bundle: Bundle(for: type(of: self)), comment: defaultUserNamePlaceHolder)
        
        self.passwordField?.placeholder = NSLocalizedString(defaultPasswordPlaceHolder, bundle: Bundle(for: type(of: self)), comment: defaultPasswordPlaceHolder)
        
    }
    
    func setColor() {
        if let headerTextColor = self.headingTextColor {
            self.headingLabel.textColor = headerTextColor
        }
        
        if let footerTextColor = self.footerTextColor {
            self.footerLabel.textColor = footerTextColor
        }
        
        if let spinnerColor = self.spinnerColor {
            self.spinner.color = spinnerColor
        }
        
        if let inputFieldBackgroundColor = self.inputFieldBackgroundColor {
            usernameField?.backgroundColor = inputFieldBackgroundColor
            passwordField?.backgroundColor = inputFieldBackgroundColor
        }
        
        if let inputFieldTextColor = self.inputFieldTextColor {
            usernameField?.textColor = inputFieldTextColor
            passwordField?.textColor = inputFieldTextColor
        }
        
        if let signInButtonTextColor = self.signInButtonTextColor {
            signInButton?.setTitleColor(signInButtonTextColor, for: UIControlState.normal)
            signInButton?.setTitleColor(signInButtonTextColor, for: UIControlState.selected)
        }
        
        if let signInButtonBackgroundColor = self.signInButtonBackgroundColor {
            signInButton?.backgroundColor = signInButtonBackgroundColor
        }
        
        setColorAccordingToCurrentDevice()
        
    }
    
    func setColorAccordingToCurrentDevice() {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            form.backgroundColor = UIColor.clear
            usernameField?.backgroundColor = Colors.white
            passwordField?.backgroundColor = Colors.white
            break
        case .pad:
            form.backgroundColor = insetBackgroundColor
            if let logo = self.logo {
                self.logoImageView.image = logo
            }
            
            usernameField?.backgroundColor = colorFromHexString("#efeff0", alpha: 1.0)
            passwordField?.backgroundColor = colorFromHexString("#efeff0", alpha: 1.0)
            self.headingLabel.textColor = UIColor.black
            self.rememberMeLabel.textColor = UIColor.black
            break
        default: break
        }
        
    }
    
    //**************************************************
    // MARK: - Override Public Methods
    //**************************************************

    override open func enabledInterface(_ enabled: Bool, spinner: Bool = false) {
        if spinner {
            self.spinner?.startAnimating()
        } else {
            self.spinner?.stopAnimating()
        }
        
        self.interactionBlockView.isHidden = enabled
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.configNotifications()
        self.configLoginScreen()

    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // enable the sign in button
        self.enabledInterface(true)
        self.hideKeyboardWhenTappedAround()
    }
    
}
