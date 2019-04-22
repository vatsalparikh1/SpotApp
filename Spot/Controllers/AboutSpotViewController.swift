//
//  AboutSpotViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 4/20/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
class AboutSpotViewController: UIViewController {
    
    var spotID : String?
    let db: Firestore! = Firestore.firestore()
    var imageURL : String?
    var spotImg : UIImage!
    
    
    @IBOutlet weak var spotImgView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    @IBOutlet weak var openLabel: UILabel!
    
    @IBOutlet weak var aboutTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        descriptionLabel.textColor = UIColor.white
        tag1.textColor = UIColor.white
        tag2.textColor = UIColor.white
        tag3.textColor = UIColor.white
        addressLabel.textColor = UIColor.white
        phoneNumLabel.textColor = UIColor.white
        openLabel.textColor = UIColor.white
        
        aboutTitle.text = "Overview"
        aboutTitle.textColor = UIColor.white
        aboutTitle.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        DispatchQueue.global().async{
            let dispatch = DispatchGroup()
            
            dispatch.enter()
            self.db.collection("spots").document(self.spotID!).getDocument { (snapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else{
                    
                    self.imageURL = snapshot?.get("image url") as? String
                    self.descriptionLabel.text = snapshot?.get("description") as? String
                    self.tag1.text = "art"
                    self.tag2.text = "painting"
                    self.tag3.text = "landmarks"
                    
                    self.addressLabel.text = "Chapel Hill, NC"
                    
                }
                
                dispatch.leave()
                
            }
            
            dispatch.wait()
            print(self.imageURL)
            
            dispatch.wait()
            
            DispatchQueue.main.sync{
                //download image from Firebase Storage
                let gsReference = Storage.storage().reference(forURL: self.imageURL!)
                gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if error != nil {
                        print("error occured")
                    } else {
                        let image = UIImage(data: data!)
                        
                        self.spotImg = image
                        
                        self.spotImgView.image = self.spotImg
                    }
                }
                
            }
        }
        // Do any additional setup after loading the view.
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
