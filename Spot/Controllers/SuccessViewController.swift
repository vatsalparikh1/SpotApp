//
//  SuccessViewController.swift
//  Spot
//
//  Created by Sunjeev Gururangan on 4/7/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        
        let textLayer = UILabel(frame: CGRect(x: 24, y: 311, width: 327, height: 63))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor(red:0.31, green:0.89, blue:0.76, alpha:1)
        textLayer.textAlignment = .center
        let textContent = "All set. Thanks for your submission. If your spot is approved, you’ll get a notification in a couple days."
        let textString = NSMutableAttributedString(string: textContent, attributes: [    NSAttributedString.Key.font: UIFont(name: "Arial", size: 18)!])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.17
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.view.addSubview(textLayer)
        
        let image = UIImage(named: "AddSpotCircleChecked2x.png")
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 166.75, y: 390.75, width: 41.5, height: 41.5)
        self.view.addSubview(imageView)
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
