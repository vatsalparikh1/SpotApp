//
//  EditProfileViewController.swift
//  Spot
//
//  Created by nishit on 4/17/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import Geofirestore
class EditProfileViewController: UIViewController {

    let userID: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    var userBioTextField: UITextField!
    var profilePic: UIImageView!
    let currentUserID: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    let db = Firestore.firestore()
    let imgPicker = UIImagePickerController()
    var urlStr : String = " "
    
    @IBOutlet weak var backButton: UIButton!

    override func viewDidLoad() {
        
        imgPicker.delegate = self

        super.viewDidLoad()
        
        
        //top rectangle with a gradient
        let topRectangle = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 87))
        let topRectangleGradient = CAGradientLayer()
        topRectangleGradient.frame = CGRect(x: 0, y: 0, width: 375, height: 87)
        topRectangleGradient.colors = [
            UIColor.black.cgColor,
            UIColor(red:0.17, green:0.17, blue:0.17, alpha:1).cgColor
        ]
        topRectangleGradient.locations = [0, 1]
        topRectangleGradient.startPoint = CGPoint(x: 0.5, y: 0.16)
        topRectangleGradient.endPoint = CGPoint(x: 0.5, y: 1.13)
        topRectangle.layer.addSublayer(topRectangleGradient)
        self.view.addSubview(topRectangle)
        
        //BackButton
        self.view.addSubview(backButton)
        self.view.bringSubviewToFront(backButton)
        backButton.layer.cornerRadius = 12
        backButton.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        backButton.layer.borderWidth = 2.4
        backButton.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        
        
        //Post button
        let postBtn = UIButton(frame: CGRect(x: 312, y: 54, width: 51, height: 24))
        postBtn.layer.cornerRadius = 12
        postBtn.backgroundColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        postBtn.layer.borderWidth = 2.4
        postBtn.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        postBtn.addTarget(self, action: #selector(self.handleCreatePost), for: .touchUpInside)
        self.view.addSubview(postBtn)
        
        
        //Post button label
        let postLabel = UILabel(frame: CGRect(x: 324, y: 59, width: 28, height: 14))
        postLabel.lineBreakMode = .byWordWrapping
        postLabel.numberOfLines = 0
        postLabel.textColor = UIColor.white
        postLabel.textAlignment = .center
        let postLabelContent = "Post"
        let paragraphStyle = NSMutableParagraphStyle()
        let postLabelString = NSMutableAttributedString(string: postLabelContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!
            ])
        let postLabelRange = NSRange(location: 0, length: postLabelString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        postLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: postLabelRange)
        postLabel.attributedText = postLabelString
        postLabel.sizeToFit()
        self.view.addSubview(postLabel)
        
        
        //Edit Profile Label
        let spotName = UILabel(frame: CGRect(x: 120, y: 45, width: 325, height: 24))
        spotName.lineBreakMode = .byWordWrapping
        spotName.numberOfLines = 0
        spotName.textColor = UIColor.white
        spotName.textAlignment = .center
        let spotNameContent = "Edit Profile"
        let spotNameString = NSMutableAttributedString(string: spotNameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 24)!
            ])
        let spotNameRange = NSRange(location: 0, length: spotNameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        spotNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: spotNameRange)
        spotNameString.addAttribute(NSAttributedString.Key.kern, value: 1.38, range: spotNameRange)
        spotName.attributedText = spotNameString
        spotName.sizeToFit()
        self.view.addSubview(spotName)
        
        //Gallery image
        let galleryFrame = UIImageView(frame: CGRect(x: 150, y: 200, width: 84, height: 48))
        galleryFrame.image = UIImage(named: "AddPostPhotoLibrary.png")
        galleryFrame.contentMode = UIView.ContentMode.scaleAspectFill
        galleryFrame.isUserInteractionEnabled = true
        let galleryRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCamRoll))
        galleryFrame.addGestureRecognizer(galleryRecognizer)
        self.view.addSubview(galleryFrame)
        
        //Camera image
        let cameraFrame = UIImageView(frame: CGRect(x: 150, y: 143, width: 84, height: 48))
        cameraFrame.image = UIImage(named: "AddPostCamera.png")
        cameraFrame.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.addSubview(cameraFrame)
        
        
        //picture label
        let picLabel = UILabel(frame: CGRect(x: 16, y: 119, width: 171, height: 16))
        picLabel.lineBreakMode = .byWordWrapping
        picLabel.numberOfLines = 0
        picLabel.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let picLabelContent = "PICTURE"
        let picLabelString = NSMutableAttributedString(string: picLabelContent, attributes: [    NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!])
        let picLabelRange = NSRange(location: 0, length: picLabelString.length)
        paragraphStyle.lineSpacing = 1.13
        picLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: picLabelRange)
        picLabelString.addAttribute(NSAttributedString.Key.kern, value: 1, range: picLabelRange)
        picLabel.attributedText = picLabelString
        picLabel.sizeToFit()
        self.view.addSubview(picLabel)
        
        //Box to display picture
        profilePic = UIImageView(frame: CGRect(x: 16, y: 143, width: 111, height: 131))
        profilePic.layer.cornerRadius = 5
        profilePic.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        profilePic.layer.borderWidth = 0.75
        profilePic.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        self.view.addSubview(profilePic)

        // Enter Bio Label
        let bioLabel = UILabel(frame: CGRect(x: 16, y: 364, width: 171, height: 16))
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.numberOfLines = 0
        bioLabel.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let bioLabelContent = "Change Bio"
        let bioLabelString = NSMutableAttributedString(string: bioLabelContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let bioLabelRange = NSRange(location: 0, length: bioLabelString.length)
        paragraphStyle.lineSpacing = 1.13
        bioLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: bioLabelRange)
        bioLabelString.addAttribute(NSAttributedString.Key.kern, value: 1, range: bioLabelRange)
        bioLabel.attributedText = bioLabelString
        bioLabel.sizeToFit()
        self.view.addSubview(bioLabel)
        
        //Description textfield
        userBioTextField = UITextField(frame: CGRect(x: 16, y: 385, width: 343, height: 58))
        userBioTextField.layer.cornerRadius = 5
        userBioTextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        userBioTextField.layer.borderWidth = 0.75
        userBioTextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        userBioTextField.textColor = UIColor.white
        self.view.addSubview(userBioTextField)
        
    }
    //end of LoadView
    
    @objc func handleCreatePost(_sender: AnyObject){
        let userBio = self.userBioTextField.text
        
        if userBio == "" {
            print ("No Bio updated")
        }
        else {
            let values = ["userBio" : userBio!,
                          ] as [String : Any]
            
            self.db.collection("users").document(self.userID).setData(values, merge: true)
            print("post created")
            
        }
        
        // to check if an image and Bio has been updated
        if profilePic.image == nil {
            print ("No image updated")
            if userBio == "" {
                self.createAlert(title: "No Changes have been made", message: "No changes have been made!")
            }
            else {
                self.createAlert(title: "Post Updated", message: "Bio: Updated , Profile Image: Not Updated")
            }
            
        }
        else { //profile pic is not nil
            if userBio == "" {
                self.uploadPostImage(profilePic.image!, userId: userID) { error in
                    if error == nil{
                        print("imaged saved to db")
                    }
                }
                self.createAlert(title: "Post Updated", message: "Bio: Not Updated , Profile Image: Updated")
            }
            else {
                self.uploadPostImage(profilePic.image!, userId: userID) { error in
                    if error == nil{
                        print("imaged saved to db")
                        
                    }
                }
                self.createAlert(title: "Post Updated", message: "Your Profile has been Updated")
            }
            
        }
        
        
    }//function end
    
    // this block of code checks if bio and profile icon have been updated
    // alert when post button is clicked
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadPostImage(_ image:UIImage, userId: String,  completion: @escaping ((_ url:String?) -> ())){
        
        let imageId = UUID().uuidString
        let storageRef = Storage.storage().reference().child("spotPics-dev").child("\(imageId)")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else{return}
        
        var urlStr: String = ""
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.putData(imageData, metadata: metadata){metadata, error in
            
            if error == nil, metadata != nil{
                //get download url
                storageRef.downloadURL(completion: { url, error in
                    if let error = error{
                        print("\(error.localizedDescription)")
                        
                    }
                    //url
                    urlStr = (url?.absoluteString)!
                    print(urlStr)
                    
                    let values = ["image url": urlStr]
                    self.db.collection("users").document(self.userID).setData(values, merge:true)
                    
                })
                
                print("display url:")
                print(urlStr)
                
            }else{
                completion(nil)
            }
        }
    }
    
    
    @objc func openCamRoll(_sender: AnyObject){
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker : UIImage?
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = image
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = image
        }
        
        if let selectedImage = selectedImageFromPicker{
            profilePic.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let navVC = segue.destinationViewController as? UINavigationController{
    //            if let historyVC = navVC.viewControllers[0] as? HistoryController{
    //                historyVC.detailItem = barcodeInt as AnyObject
    //            }
    //        }
    //    }
    
    
    
}
