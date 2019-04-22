//
//  ViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 2/4/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class SignUpViewController: UIViewController {
    
    //Change status bar theme color white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    //Creates variables to be used when generating text fields
    //This works but do they need to be weak variables??? -> Need to find out
    weak var nameField: UITextField!
    weak var emailField: UITextField!
    weak var usernameField: UITextField!
    weak var pwdField: UITextField!
    var errorBox: UIView!
    var errorTextLayer: UILabel!
    
    override func viewDidLoad() {
        
        //If user is already logged in, then this will take them directly to the map.
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                print("user signed in")
                self.performSegue(withIdentifier: "signUpToTabBar", sender: self)
            }
        }
        
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
        
        //Load "Create Account"
        let createAccountLayer = UILabel(frame: CGRect(x: 38, y: 108, width: 266, height: 38))
        createAccountLayer.lineBreakMode = .byWordWrapping
        createAccountLayer.numberOfLines = 0
        createAccountLayer.textColor = UIColor.white
        let createAccountContent = "Create account"
        let createAccountString = NSMutableAttributedString(string: createAccountContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 28)!
            ])
        let createAccountRange = NSRange(location: 0, length: createAccountString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.21
        createAccountString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: createAccountRange)
        createAccountLayer.attributedText = createAccountString
        createAccountLayer.sizeToFit()
        self.view.addSubview(createAccountLayer)
        
        
        //Load 'name' label
        let nameLayer = UILabel(frame: CGRect(x: 39, y: 155, width: 170, height: 16))
        nameLayer.lineBreakMode = .byWordWrapping
        nameLayer.numberOfLines = 0
        nameLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let nameContent = "name"
        let nameString = NSMutableAttributedString(string: nameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let nameRange = NSRange(location: 0, length: nameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        nameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: nameRange)
        nameLayer.attributedText = nameString
        nameLayer.sizeToFit()
        self.view.addSubview(nameLayer)
        
        
        //Load 'name' text field
        nameField = UITextField(frame: CGRect(x: 38, y: 174, width: 299.02, height: 36))
        nameField.layer.cornerRadius = 5
        nameField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(nameField)
        nameField.textColor = UIColor.white
        nameField.autocorrectionType = .no
        
        
        //Load email label
        let emailLayer = UILabel(frame: CGRect(x: 39, y: 223, width: 170, height: 16))
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
        
        emailField = UITextField(frame: CGRect(x: 38, y: 242, width: 299.02, height: 36))
        emailField.layer.cornerRadius = 5
        emailField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(emailField)
        emailField.textColor = UIColor.white
        emailField.autocorrectionType = .no
        
        //load username label
        
        let usernameLayer = UILabel(frame: CGRect(x: 39, y: 291, width: 170, height: 16))
        usernameLayer.lineBreakMode = .byWordWrapping
        usernameLayer.numberOfLines = 0
        usernameLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let usernameContent = "username"
        let usernameString = NSMutableAttributedString(string: usernameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 14)!
            ])
        let usernameRange = NSRange(location: 0, length: usernameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.14
        usernameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: usernameRange)
        usernameLayer.attributedText = usernameString
        usernameLayer.sizeToFit()
        self.view.addSubview(usernameLayer)
        
        //load username text field
        
        usernameField = UITextField(frame: CGRect(x: 38, y: 310, width: 299.02, height: 36))
        usernameField.layer.cornerRadius = 5
        usernameField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(usernameField)
        usernameField.textColor = UIColor.white
        usernameField.autocorrectionType = .no
        
        
        //load password label
        let pwdLayer = UILabel(frame: CGRect(x: 39, y: 359, width: 78, height: 16))
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
        
        //load pwd min characters label
        let pwdMinLayer = UILabel(frame: CGRect(x: 112, y: 362, width: 223, height: 12))
        pwdMinLayer.lineBreakMode = .byWordWrapping
        pwdMinLayer.numberOfLines = 0
        pwdMinLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let pwdMinContent = "min 6 characters"
        let pwdMinString = NSMutableAttributedString(string: pwdMinContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 10)!
            ])
        let pwdMinRange = NSRange(location: 0, length: pwdMinString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        pwdMinString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: pwdMinRange)
        pwdMinLayer.attributedText = pwdMinString
        pwdMinLayer.sizeToFit()
        self.view.addSubview(pwdMinLayer)
        
        //load password text field
        pwdField = UITextField(frame: CGRect(x: 38, y: 378, width: 299.02, height: 36))
        pwdField.layer.cornerRadius = 5
        pwdField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        self.view.addSubview(pwdField)
        pwdField.isSecureTextEntry = true
        pwdField.textColor = UIColor.white
        pwdField.autocorrectionType = .no
        
        //Load 'Go' button background
        let goBtnBackground = UIView(frame: CGRect(x: 134, y: 432, width: 108, height: 30))
        goBtnBackground.layer.cornerRadius = 8
        goBtnBackground.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        self.view.addSubview(goBtnBackground)
        
        //Load 'Go' button text
        let goText = UILabel(frame: CGRect(x: 177, y: 438, width: 178, height: 19))
        goText.lineBreakMode = .byWordWrapping
        goText.numberOfLines = 0
        goText.textColor = UIColor.white
        goText.textAlignment = .center
        let goTextContent = "GO"
        let goTextString = NSMutableAttributedString(string: goTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let goTextRange = NSRange(location: 0, length: goTextString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        goTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: goTextRange)
        goText.attributedText = goTextString
        goText.sizeToFit()
        self.view.addSubview(goText)
        
        
        //Load 'already have an account'
        
        let alreadyhave = UILabel(frame: CGRect(x: 100, y: 709, width: 223, height: 19))
        alreadyhave.lineBreakMode = .byWordWrapping
        alreadyhave.numberOfLines = 0
        alreadyhave.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
        alreadyhave.textAlignment = .center
        let alreadyhaveContent = "Already have an account? "
        let alreadyhaveString = NSMutableAttributedString(string: alreadyhaveContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let alreadyhaveRange = NSRange(location: 0, length: alreadyhaveString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        alreadyhaveString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: alreadyhaveRange)
        alreadyhave.attributedText = alreadyhaveString
        alreadyhave.sizeToFit()
        self.view.addSubview(alreadyhave)
        
        //Load 'login' button
        let loginBtn = UILabel(frame: CGRect(x: 170, y: 728, width: 130, height: 45))
        loginBtn.lineBreakMode = .byWordWrapping
        loginBtn.numberOfLines = 0
        loginBtn.textColor = UIColor.white
        loginBtn.textAlignment = .center
        let loginContent = "Log in"
        let loginString = NSMutableAttributedString(string: loginContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 20)!
            ])
        let loginRange = NSRange(location: 0, length: loginString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        loginString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: loginRange)
        loginBtn.attributedText = loginString
        loginBtn.sizeToFit()
        self.view.addSubview(loginBtn)
        
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
        
        
        //run handleSignUp() when sign up button is clicked ('GO')
        goBtnBackground.isUserInteractionEnabled = true
        let signupRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSignUp))
        goBtnBackground.addGestureRecognizer(signupRecognizer)
        
        
        //run goToLoginPage() when button is clicked
        loginBtn.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goToLoginPage))
        loginBtn.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func goToLoginPage(_sender: AnyObject){
        self.performSegue(withIdentifier: "signupToLogin", sender: self) //Go to intro page
    }
    
    
    @objc func handleSignUp(_sender: AnyObject){
        
        //gets the text values from the text boxes
        guard let name = nameField.text else{return}
        guard let username = usernameField.text else{return}
        guard let email = emailField.text else{return}
        guard let password = pwdField.text else{return}
        

        //Checks to see if there is text field without text entered into it
        if (!self.allFieldsComplete(name: name, username: username, email: email, password: password)){
            print("complete all fields to create account")
        }else{//if there is text in all fields, proceeds to authentication
            
            Auth.auth().createUser(withEmail: email, password: password){//authenticate user
                user, error in
                
                if error == nil && user != nil { //if no errors then create user
                    print("user created")
                    self.saveUserToFirebase(name:name, username: username, email: email)
                    self.performSegue(withIdentifier: "signUpToInfo", sender: self) //Go to intro page
                }else{
                    print(error?.localizedDescription ?? "Sign-up Error")
                    
                    self.errorBox.isHidden = false
                    self.errorTextLayer.isHidden = false
                    self.errorTextLayer.text = "ERROR Email address already in use"
                    
                    
                    
                }
            }
        }
        
        
        
    }
    
    //add new user's account to firestore w/ uid key and name,email,username value pairs
    private func saveUserToFirebase(name: String, username: String, email: String){
        let db = Firestore.firestore()
        
        guard let userId = Auth.auth().currentUser?.uid else{return}
        
        var friendsList : [String] = [] 
        var spotsList : [String] = []
        
        let values = ["name" : name,
                      "email" : email,
                      "username" : username,
                      "userBio" : "",
                      "friendsList" :  friendsList,
                      "spotsList" : spotsList
            ] as [String : Any]
        
        db.collection("users").document(userId).setData(values, merge: true)
        
        
    }
    
    //Function checks to see if text is entered into all fields
    private func allFieldsComplete(name:String, username:String,email:String,password:String) -> Bool{
        errorBox.isHidden = true
        errorTextLayer.isHidden = true
        
        
        if name.isEmpty{
            errorBox.isHidden = false
            errorTextLayer.isHidden = false
            errorTextLayer.text = "ERROR Please enter your name"
            
            print("name is empty")
            return false;
        }
        if !isValidEmail(email: email){
            errorBox.isHidden = false
            errorTextLayer.isHidden = false
            errorTextLayer.text = "ERROR Please enter a valid email"
            
            print("invalid email")
            return false;
        }
        if username.isEmpty{
            errorBox.isHidden = false
            errorTextLayer.isHidden = false
            errorTextLayer.text = "ERROR Please enter a username"
            
            print("username is empty")
            return false;
        }
        if password.count < 6{
            errorBox.isHidden = false
            errorTextLayer.isHidden = false
            errorTextLayer.text = "ERROR Please enter a valid password"
            
            print("password must be at least 6 characters")
            return false;
        }
        print("all fields entered in proper format")
        return true;
    }
    
    
    //checks to see if valid email is entered
    func isValidEmail(email:String?) -> Bool {
        guard email != nil else { return false }
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    //Hide keyboard when user touches screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
}

