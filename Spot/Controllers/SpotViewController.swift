//
//  SpotViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 4/18/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class SpotViewController: UIViewController {
    
    var spotId : String!
    let db: Firestore! = Firestore.firestore()
    var spotName: String!
    
    
  
    @IBOutlet weak var segUI: UISegmentedControl!
    
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var aboutView: UIView!
    
    @IBAction func switchView(_ sender: UISegmentedControl) {
        switch segUI.selectedSegmentIndex{
        case 0:
            self.aboutView.isHidden = true
            self.postView.isHidden = true
        case 1:
            self.aboutView.isHidden = false
            self.postView.isHidden = true
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        segUI.selectedSegmentIndex = 1
        
        DispatchQueue.global().async{
            let dispatch = DispatchGroup()
            
            dispatch.enter()
            self.db.collection("spots").document(self.spotId).getDocument { (snapshot, err) in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else{
                    
                    self.spotName = snapshot?.get("spot name") as? String
                    
                    //need to query list of user's friends and store them in a global variable
                    
                }
                
                dispatch.leave()
                
            }
            
            dispatch.wait()
            DispatchQueue.main.sync{
                print(self.spotName)
                self.title = self.spotName
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func backAction(){
        //self.performSegue(withIdentifier: "spotPageBackToMap", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print(self.spotId)
        if segue.identifier == "spotPageToAbout"{
            //if let destination = segue.destination as? UITabBarController,
            if let vc = segue.destination as? AboutSpotViewController{
                vc.spotID = self.spotId
            }
        }
        
        if segue.identifier == "spotPageToPost"{
            if let vc = segue.destination as? SpotPagePostViewController{
                vc.spotID = self.spotId
            }
        }
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
