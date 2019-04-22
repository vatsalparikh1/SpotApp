//
//  SpotsButtonViewController.swift
//
//
//  Created by nishit on 4/4/19.
//
import UIKit

class SpotsButtonViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    func reloadContent(_ buttonName: String){
        label.text = buttonName
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
