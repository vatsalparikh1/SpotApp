//  AddSpotViewController.swift
//  Spot
//
//  Created by Created by Vatsal Parikh on 4/7/19.
//  Copyright © 2019 comp523. All rights reserved.
//
import UIKit
import Firebase
import MapKit
import Geofirestore
class CreatePostViewController: UIViewController{
    
    let userID: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    var captionTextField: UITextField!
    var spotPic: UIImageView!
    let currentUserID: String = Auth.auth().currentUser?.uid ?? "invalid ID"
    let db = Firestore.firestore()
    let imgPicker = UIImagePickerController()
    var urlStr : String = " "
    
    var spotID : String!
    
    //hard coded for now, will change, need to get this value from previous page
    //let spotID: String = "NZNdh5JLF3xwFykXubdY"
    
    
    override func viewDidLoad() {
        
        imgPicker.delegate = self
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        
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
        
        
        //Cancel button
        let cancelBtn = UILabel(frame: CGRect(x: 12, y: 56, width: 186, height: 23))
        cancelBtn.lineBreakMode = .byWordWrapping
        cancelBtn.numberOfLines = 0
        cancelBtn.textColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1)
        let cancelBtnContent = "Cancel"
        let cancelBtnString = NSMutableAttributedString(string: cancelBtnContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let cancelBtnRange = NSRange(location: 0, length: cancelBtnString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.19
        cancelBtnString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: cancelBtnRange)
        cancelBtn.attributedText = cancelBtnString
        cancelBtn.sizeToFit()
        self.view.addSubview(cancelBtn)


        Firestore.firestore().collection("spots").document(self.spotID).getDocument { (snapshot, err) in
            
            
        //Display name of Spot
        let spotName = UILabel(frame: CGRect(x: 120, y: 45, width: 325, height: 24))
        spotName.lineBreakMode = .byWordWrapping
        spotName.numberOfLines = 0
        spotName.textColor = UIColor.white
        spotName.textAlignment = .center
        let spotNameContent = snapshot?.get("spot name") as! String
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
            
        }
        
        //Display name of city
        let cityName = UILabel(frame: CGRect(x: 145, y: 69, width: 186, height: 15))
        cityName.lineBreakMode = .byWordWrapping
        cityName.numberOfLines = 0
        cityName.textColor = UIColor(red:0.76, green:0.76, blue:0.76, alpha:1)
        cityName.textAlignment = .center
        let cityNameContent = "Chapel Hill, NC"
        let cityNameString = NSMutableAttributedString(string: cityNameContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 12)!
            ])
        let cityNameRange = NSRange(location: 0, length: cityNameString.length)
        _ = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        cityNameString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: cityNameRange)
        cityName.attributedText = cityNameString
        cityName.sizeToFit()
        self.view.addSubview(cityName)

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
        spotPic = UIImageView(frame: CGRect(x: 16, y: 143, width: 111, height: 131))
        spotPic.layer.cornerRadius = 5
        spotPic.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        spotPic.layer.borderWidth = 0.75
        spotPic.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        self.view.addSubview(spotPic)
        
        //Caption label
        let captionLabel = UILabel(frame: CGRect(x: 16, y: 364, width: 171, height: 16))
        captionLabel.lineBreakMode = .byWordWrapping
        captionLabel.numberOfLines = 0
        captionLabel.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        let captionLabelContent = "CAPTION"
        let captionLabelString = NSMutableAttributedString(string: captionLabelContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 16)!
            ])
        let captionLabelRange = NSRange(location: 0, length: captionLabelString.length)
        paragraphStyle.lineSpacing = 1.13
        captionLabelString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: captionLabelRange)
        captionLabelString.addAttribute(NSAttributedString.Key.kern, value: 1, range: captionLabelRange)
        captionLabel.attributedText = captionLabelString
        captionLabel.sizeToFit()
        self.view.addSubview(captionLabel)
        
        //Description textfield
        captionTextField = UITextField(frame: CGRect(x: 16, y: 385, width: 343, height: 58))
        captionTextField.layer.cornerRadius = 5
        captionTextField.backgroundColor = UIColor(red:0.85, green:0.85, blue:0.85, alpha:0.1)
        captionTextField.layer.borderWidth = 0.75
        captionTextField.layer.borderColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1).cgColor
        captionTextField.textColor = UIColor.white
        self.view.addSubview(captionTextField)
        
    }
    
    @objc func openCamRoll(_sender: AnyObject){
        imgPicker.sourceType = .photoLibrary
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true, completion: nil)
    }
    
    @objc func handleCreatePost(_sender: AnyObject){
        let postId = UUID().uuidString
        let caption = self.captionTextField.text
        let posterID = self.currentUserID
        
        //Get the time that the post was created
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        var likersList : [String] = []
        
        let values = ["caption" : caption,
                      "posterID" : posterID,
                      "timestamp" : time,
                      "numLikes" : 0,
                      "likers" : likersList
            ] as [String : Any]
        self.db.collection("spots").document(self.spotID).collection("feedPost").document(postId).setData(values, merge: true)
        print("post created")
        
        self.uploadPostImage(spotPic.image!, postId: postId) { error in
            if error == nil{
                print("imaged saved to db")
            }
        }
        
        print("image uploaded")
        
        self.performSegue(withIdentifier: "leaveCreate", sender: self) //Go to tab view page
        
        
    }
    
    func uploadPostImage(_ image:UIImage, postId: String,  completion: @escaping ((_ url:String?) -> ())){
        
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
                    self.db.collection("spots").document(self.spotID).collection("feedPost").document(postId).setData(values, merge:true)
                    
                })
                
                print("display url:")
                print(urlStr)
                
            }else{
                completion(nil)
            }
        }
    }
    
}


extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker : UIImage?
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImageFromPicker = image
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImageFromPicker = image
        }
        
        if let selectedImage = selectedImageFromPicker{
            spotPic.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}



