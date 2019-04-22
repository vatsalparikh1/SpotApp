//
//  MarkerInfoWindow.swift
//  Spot
//
//  Created by Victoria Elaine Maxwell on 3/8/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import UIKit

class MarkerInfoWindow: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var spotImage: UIImageView!
    
    var spotData: Dictionary<String, Any>?
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MarkerInfoWindowView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
    }

}
