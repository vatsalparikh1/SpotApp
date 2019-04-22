//
//  LoginViewController.swift
//  Spot
//
//  Created by Vatsal Parikh on 2/13/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


//This file controls the loginView
class LoginViewController: UIViewController {
    
    //Change status bar theme color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Initializes text field variables
    weak var emailField: UITextField!
    weak var pwdField: UITextField!
    var errorBox: UIView!
    var errorTextLayer: UILabel!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Load User Interface Elements according to Invision
        
        //Display background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "SignUpBackground.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        //Load Spot Logo
        let logoPath = "Signuplogo.png"
        let logoImage = UIImage(named: logoPath)
        let logoImageView = UIImageView(image: logoImage!)
        
        logoImageView.frame = CGRect(x: 150, y: 45, width: 75, height: 22)
        view.addSubview(logoImageView)
        
        //Load "Rediscover Your World"
        let sloganTextLayer = UILabel(frame: CGRect(x: 99, y: 73, width: 178, height: 15))
        sloganTextLayer.lineBreakMode = .byWordWrapping
        sloganTextLayer.numberOfLines = 0
        sloganTextLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        sloganTextLayer.textAlignment = .center
        let sloganTextContent = "REDISCOVER YOUR WORLD"
        let sloganTextString = NSMutableAttributedString(string: sloganTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Menlo-Bold", size: 13)!
            ])
        let sloganTextRange = NSRange(location: 0, length: sloganTextString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.15
        sloganTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: sloganTextRange)
        sloganTextLayer.attributedText = sloganTextString
        sloganTextLayer.sizeToFit()
        self.view.addSubview(sloganTextLayer)
        
        
        //Load arrow container
        let arrowContainer = UIView(frame: CGRect(x: 15, y: 56, width: 12, height: 20))
        self.view.addSubview(arrowContainer)
        
        
        //Load back arrow (top)
        let backArrowTop = UIView(frame: CGRect(x: 19.68, y: 64, width: 2.5, height: 14))
        var transformTop = CGAffineTransform.identity
        transformTop = transformTop.rotated(by: 2.356194490192345)
        backArrowTop.transform = transformTop
        backArrowTop.layer.cornerRadius = 0.75
        backArrowTop.backgroundColor = UIColor.white
        self.view.addSubview(backArrowTop)
        
        //Load back arrow (bottom)
        let backArrowBottom = UIView(frame: CGRect(x: 19.68, y: 56, width: 2.5, height: 14))
        var transformBottom = CGAffineTransform.identity
        transformBottom = transformBottom.rotated(by: -2.356194490192345)
        backArrowBottom.transform = transformBottom
        backArrowBottom.layer.cornerRadius = 0.75
        backArrowBottom.backgroundColor = UIColor.white
        self.view.addSubview(backArrowBottom)
        
        
        //Load 'Log in' label
        let loginLayer = UILabel(frame: CGRect(x: 38, y: 180, width: 130, height: 38))
        loginLayer.lineBreakMode = .byWordWrapping
        loginLayer.numberOfLines = 0
        loginLayer.textColor = UIColor.white
        let loginContent = "Log in"
        let loginString = NSMutableAttributedString(string: loginContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 32)!
            ])
        let loginRange = NSRange(location: 0, length: loginString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        loginString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: loginRange)
        loginLayer.attributedText = loginString
        loginLayer.sizeToFit()
        self.view.addSubview(loginLayer)
        
        
        
        //load email label
        
        let emailLayer = UILabel(frame: CGRect(x: 39, y: 234, width: 170, height: 16))
        emailLayer.lineBreakMode = .byWordWrapping
        emailLayer.numberOfLines = 0
        emailLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let emailContent = "email"
        let emailString = NSMutableAttributedString(string: emailContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let emailRange = NSRange(location: 0, length: emailString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        emailString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: emailRange)
        emailLayer.attributedText = emailString
        emailLayer.sizeToFit()
        self.view.addSubview(emailLayer)
        
        
        
        //load email text field
        emailField = UITextField(frame: CGRect(x: 38, y: 253, width: 299.02, height: 36))
        emailField.layer.cornerRadius = 5
        emailField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(emailField)
        emailField.textColor = UIColor.white
        emailField.autocorrectionType = .no
        
        
        //load password label
        let pwdLayer = UILabel(frame: CGRect(x: 39, y: 302, width: 170, height: 16))
        pwdLayer.lineBreakMode = .byWordWrapping
        pwdLayer.numberOfLines = 0
        pwdLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let pwdContent = "password"
        let pwdString = NSMutableAttributedString(string: pwdContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let pwdRange = NSRange(location: 0, length: pwdString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        pwdString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: pwdRange)
        pwdLayer.attributedText = pwdString
        pwdLayer.sizeToFit()
        self.view.addSubview(pwdLayer)
        
        
        //load password text field
        
        pwdField = UITextField(frame: CGRect(x: 38, y: 321, width: 299.02, height: 36))
        pwdField.layer.cornerRadius = 5
        pwdField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(pwdField)
        pwdField.isSecureTextEntry = true
        pwdField.textColor = UIColor.white
        pwdField.autocorrectionType = .no

        
        //Load 'Forgot Password' (fp) button
        let fpLayer = UILabel(frame: CGRect(x: 134, y: 374, width: 138, height: 19))
        fpLayer.lineBreakMode = .byWordWrapping
        fpLayer.numberOfLines = 0
        fpLayer.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        let fpContent = "Forgot password?"
        let fpString = NSMutableAttributedString(string: fpContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let fpRange = NSRange(location: 0, length: fpString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        fpString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: fpRange)
        fpLayer.attributedText = fpString
        fpLayer.sizeToFit()
        self.view.addSubview(fpLayer)
        
        
        //Load 'LOG IN' button background
        let loginBtnBackground = UIView(frame: CGRect(x: 134, y: 412, width: 108, height: 32))
        loginBtnBackground.layer.cornerRadius = 8
        loginBtnBackground.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        self.view.addSubview(loginBtnBackground)
        
        
        //Load 'LOG IN' button text
        let loginBtnText = UILabel(frame: CGRect(x: 162, y: 419, width: 178, height: 19))
        loginBtnText.lineBreakMode = .byWordWrapping
        loginBtnText.numberOfLines = 0
        loginBtnText.textColor = UIColor.white
        loginBtnText.textAlignment = .center
        let loginBtnTextContent = "LOG IN"
        let loginBtnTextString = NSMutableAttributedString(string: loginBtnTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let loginBtnTextRange = NSRange(location: 0, length: loginBtnTextString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        loginBtnTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: loginBtnTextRange)
        loginBtnText.attributedText = loginBtnTextString
        loginBtnText.sizeToFit()
        self.view.addSubview(loginBtnText)
        
        
        
        //load Error box
        errorBox = UIView(frame: CGRect(x: 0, y: 489, width: 375, height: 32))
        errorBox.backgroundColor = UIColor(red:0.35, green:0, blue:0.04, alpha:1)
        self.view.addSubview(errorBox)
        errorBox.isHidden = true
        
        //Load error text
        errorTextLayer = UILabel(frame: CGRect(x: 23, y: 496, width: 329, height: 18))
        errorTextLayer.lineBreakMode = .byWordWrapping
        errorTextLayer.numberOfLines = 0
        errorTextLayer.textColor = UIColor.white
        errorTextLayer.textAlignment = .center
        let errorTextContent = "ERROR  Invalid login credentials. Please try again."
        let errorTextString = NSMutableAttributedString(string: errorTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let errorTextRange = NSRange(location: 0, length: errorTextString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        errorTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: errorTextRange)
        errorTextLayer.attributedText = errorTextString
        errorTextLayer.sizeToFit()
        self.view.addSubview(errorTextLayer)
        errorTextLayer.isHidden = true
        
        //run handleLogin() when 'LOG IN' button is clicked
        loginBtnBackground.isUserInteractionEnabled = true
        let loginRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleLogin))
        loginBtnBackground.addGestureRecognizer(loginRecognizer)
        
        //loginToSignup
        arrowContainer.isUserInteractionEnabled = true
        let backRecognizer = UITapGestureRecognizer(target: self, action: #selector(returnToSignup))
        arrowContainer.addGestureRecognizer(backRecognizer)
        
        //loginToForgot
        fpLayer.isUserInteractionEnabled = true
        let forgotRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleForgotPwd))
        fpLayer.addGestureRecognizer(forgotRecognizer)
        
    }
    
    @objc func returnToSignup(_sender: AnyObject){
        self.performSegue(withIdentifier: "loginToSignup", sender: self) //return to signup view
    }
    
    @objc func handleForgotPwd(_sender: AnyObject){
        self.performSegue(withIdentifier: "loginToForgot", sender: self) //return to signup view
    }
    
    @objc func handleLogin(_sender: AnyObject){
        
        guard let email = emailField.text else{return}
        guard let password = pwdField.text else{return}
        
        //Authenticate login information
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil && user != nil {//if no errors then allow login
                self.errorBox.isHidden = true
                self.errorTextLayer.isHidden = true
                print("success!")
                self.performSegue(withIdentifier: "loginToTab", sender: self) //Go to tab view page
            }else{
                print("login failed")
                self.errorBox.isHidden = false
                self.errorTextLayer.isHidden = false
            }
            
        }
    }
    
    //Hide keyboard when user touches screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
}
