//
//  Post.swift
//  InstaTag
//
//  Created by Victor Alfonso Barcenas Monreal on 03/02/17.
//  Copyright © 2017 Victor Barcenas. All rights reserved.
//

import Foundation

//Only 1 property added for demo purposes
class Post{
    
    private var _images:Dictionary<String,AnyObject> = Dictionary()
    
    var images:Dictionary<String,AnyObject>{
        return _images
    }
 
    init(){}
    
    init(dictionary:Dictionary<String,AnyObject>){
        if let imgs = dictionary["images"]{
            _images = imgs as! Dictionary<String,AnyObject>
        }
    }
}
