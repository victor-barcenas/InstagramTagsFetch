//
//  Constants.swift
//  InstaTag
//
//  Created by Victor Alfonso Barcenas Monreal on 02/02/17.
//  Copyright © 2017 Victor Barcenas. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Instagram {
        static let clientId = "7c2b4563d9034f029b7d71f4345bdcc9"
        static let redirectUri = "http://localhost"
        static let api = "https://api.instagram.com/v1/"
        static let server = "https://api.instagram.com/"
        static let oAuth = server + "oauth/authorize/?client_id=" + clientId + "&redirect_uri=" + redirectUri + "&response_type=token&scope=public_content"
    }
    
    struct Colors{
        static let activityIndicator:UIColor = UIColor.lightGray
        static let activityIndicatorFont:UIColor = UIColor.black
    }
    
    struct Strings{
        static let errorTitle = "Error"
        static let networkError = "There's no internet connection"
    }
}
