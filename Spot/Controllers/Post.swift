//
//  Post.swift
//  Spot
//
//  Created by Vatsal Parikh on 2/27/19.
//  Copyright © 2019 comp523. All rights reserved.
//

import Foundation

class Post {
    var spotname: String
    var caption:String
    var photo:NSObject
    var uName: String
    var numLikes: Int
    var location: String
    
    init(spotname:String, captionText:String,photoObj:NSObject,uNameString:String, likesCount:Int, location: String){
        self.spotname = spotname
        self.caption = captionText
        self.photo = photoObj
        self.uName = uNameString
        self.numLikes = likesCount
        self.location = location
        
    }
    
    func toString() -> String {
        let output = self.spotname+"|"+self.caption+"|"+self.uName+"|"+self.location
        return output
    }
}
