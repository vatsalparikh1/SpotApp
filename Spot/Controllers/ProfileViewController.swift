//
//  ProfileViewController.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 2/15/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

    let db: Firestore! = Firestore.firestore()
    let id: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    let email: String = Auth.auth().currentUser?.email ?? "Invalid User"
    var nameGlobal : String = "";
    var usernameGlobal : String = "";
    var nametestGlobal : String?;
    var usertestGlobal : String?;
    var navigationBarAppearace = UINavigationBar.appearance()
    var userHasImage = false
    var spotInt = 0;
    var friendsInt = 0;
    var friendsArray = [String]()
    var spotsInt = 0;
    var spotsArray = [String]()
    var userBioString : String = "";
    var userHasBio = false
    var userURL : String = "";

    
    @IBOutlet weak var bioText: UITextView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    private var childViewController: SpotsButtonViewController?
    @IBOutlet weak var ProfileIcon: UIImageView!
    
    
    @IBAction func onTapPhotomapButton(_ sender: Any) {
        childViewController?.reloadContent("Photomap")
    }
    
    @IBAction func onTapSpotsButton(_ sender: Any) {
        childViewController?.reloadContent("Spots")
    }
    
    
    @IBAction func onTapFriendsButton(_ sender: Any) {
        childViewController?.reloadContent("Friends")
    }
    
    //VIEW LOAD
    
    override func viewDidLoad() {
        
        
        //make profile circular and call userImage
        profileIconInsert()
        getProfileInt()
        getUserBio()
        bioText.textAlignment = .center
        super.viewDidLoad()
        
        //logout code
        logoutButton.isUserInteractionEnabled = true
        let logoutRecognizer = UITapGestureRecognizer(target: self, action: #selector(logoutFunc))
        logoutButton.addGestureRecognizer(logoutRecognizer)
        print("Logging Out")
        //
        
        
        runDispatch()
        
    }

    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    
    func runDispatch() {
        DispatchQueue.global().async {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            DispatchQueue.global().async {
                
                self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
                    
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else{
                        
                        
                        self.nameGlobal = (snapshot?.get("name") as! String)
                        self.usernameGlobal = (snapshot?.get("username") as! String)
                        
                        
                        
                        //setting the color of the title to be white
                          self.navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                        
                        
                        // Setting the title of the profile page to be the current user
                        self.title = self.usernameGlobal
                        
                        
                        
                        //Adding the Profile Name Underneath the Profile Icon
                        let profile_Name = UILabel(frame: CGRect(x: 131, y: 192, width: 201, height: 29))
                        profile_Name.lineBreakMode = .byWordWrapping
                        profile_Name.numberOfLines = 0
                        profile_Name.textColor = UIColor.white
                        profile_Name.textAlignment = .center
                        let profileContent = self.nameGlobal
                        let profileString = NSMutableAttributedString(string: profileContent, attributes: [
                            NSAttributedString.Key.font: UIFont(name: "Arial", size: 22)!
                            ])
                        let profileRange = NSRange(location: 0, length: profileString.length)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 1.18
                        profileString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: profileRange)
                        profile_Name.attributedText = profileString
                        profile_Name.sizeToFit()
                        self.view.addSubview(profile_Name)
                        //
                      
                        
                        // load Place Name underneath the Profile Name
                        let currentLocationName = UILabel(frame: CGRect(x: 150, y: 220, width: 101, height: 18))
                        currentLocationName.lineBreakMode = .byWordWrapping
                        currentLocationName.numberOfLines = 0
                        currentLocationName.textColor = UIColor(red:0.61, green:0.61, blue:0.61, alpha:1)
                        currentLocationName.textAlignment = .center
                        let currentLocationNameContent = "Chapel Hill, NC"
                        let currentLocationNameString = NSMutableAttributedString(string: currentLocationNameContent, attributes: [
                            NSAttributedString.Key.font: UIFont(name: "Arial", size: 11)!
                            ])
                        let currentLocationNameRange = NSRange(location: 0, length: currentLocationNameString.length)
                        let locationStyle = NSMutableParagraphStyle()
                        locationStyle.lineSpacing = 1.18
                        currentLocationNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:locationStyle, range: currentLocationNameRange)
                        currentLocationName.attributedText = currentLocationNameString
                        currentLocationName.sizeToFit()
                        self.view.addSubview(currentLocationName)
                        
                        
                        //need to query list of user's friends and store them in a global variable
                    }
                    dispatchGroup.leave()
                    print("Did the first thing")
                }
            }
            dispatchGroup.wait()
            print("done waiting")
        }
        
    }
    
    // GET THE NUMBER OF SPOTS AND FRIENDS
    
    func getProfileInt() {
        self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                //Getting number of friends
                self.friendsArray = snapshot?.get("friendsList") as! [String]
                self.friendsInt = self.friendsArray.count
                print ("Getting number of friends")
                print (self.friendsArray)
        
                //Getting number of Spots
                self.spotsArray = snapshot?.get("spotsList") as! [String]
                self.spotsInt = self.spotsArray.count
                print ("Getting number of spots")
                print (self.spotsArray)
                //Adding the friends number label
                let friendsIntLabel = UILabel(frame: CGRect(x: 322, y: 285, width: 50, height: 21))
                friendsIntLabel.textAlignment = .center //For center alignment
                let friendsIntString = String(self.friendsInt)
                let fIntString = "(" + friendsIntString + ")"
                friendsIntLabel.text = fIntString
                friendsIntLabel.textColor = .green
                friendsIntLabel.font = UIFont.systemFont(ofSize: 14)
                self.view.addSubview(friendsIntLabel)
                
                //Adding the Spots number label
                let spotsIntLabel = UILabel(frame: CGRect(x: 65, y: 285, width: 50, height: 21))
                spotsIntLabel.textAlignment = .center //For center alignment
                let spotsIntString = String(self.spotsInt)
                let sIntString = "(" + spotsIntString + ")"
                spotsIntLabel.text = sIntString
                spotsIntLabel.textColor = .green
                spotsIntLabel.font = UIFont.systemFont(ofSize: 14)
                self.view.addSubview(spotsIntLabel)
            }
        }
    }
    
    func getUserBio() {
        self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                //gets userBio
                self.userBioString = snapshot?.get("userBio") as! String
                print(self.userBioString)
                // checks if user has a bio
                if self.userBioString == "" {
                    self.bioText.insertText("Change Your Bio In Edit profile")
                    print ("no Bio spotted")
                }else {
                //inserts bio into textfield
                    self.bioText.insertText(self.userBioString)
                    
                }
                
            }
        }
    }
        
    
    
    func profileIconInsert() {
        //making the image circular
        ProfileIcon.layer.borderWidth = 1
        ProfileIcon.layer.masksToBounds = false
        ProfileIcon.layer.borderColor = UIColor.black.cgColor
        ProfileIcon.layer.cornerRadius = ProfileIcon.frame.height/2
        ProfileIcon.clipsToBounds = true
        //
        //
        
        self.db.collection("users").document(self.id).getDocument { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }else {
                
                self.userURL = snapshot?.get("image url") as! String
                
                // Check if User does not have a profile image saved
                if self.userURL == "" {
                    //insert stock picture
                    self.ProfileIcon.image = UIImage(named: "Profile1x.png")
                    //end gs Ref
                } else {
                    let gsReference = Storage.storage().reference(forURL: self.userURL)
                    
                    //Extract image and put it into ProfileIcon
                    gsReference.getData(maxSize: 1 * 1024 * 1024) {
                        data, error in
                        if error != nil {
                            print("error occured")
                        } else {
                            let profImage = UIImage(data: data!)
                            self.ProfileIcon.image = profImage
                        }
                    }
                }
                
            }
        }
        
        
        
        
    }
    
    
//    UnComment once you can change the font of the button programmatically
//    func setButtonTitles() {
//        let UserSpotsString = "(" + String(userSpots) + ") \nSpots"
//        SpotsView.setTitle(UserSpotsString, for: UIControl.State.normal)
//
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SpotsButtonViewController{
            self.childViewController = vc
            
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    // Segue to Navigation Controller

    
    @objc func logoutFunc(_sender: AnyObject){
        
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("logout complete 1")
        self.performSegue(withIdentifier: "logoutSegue", sender: self) //return to signup view
        print("logout complete 2")
    }

}

