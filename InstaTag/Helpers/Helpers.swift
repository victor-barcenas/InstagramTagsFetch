//
//  Helpers.swift
//  InstaTag
//
//  Created by Victor Alfonso Barcenas Monreal on 03/02/17.
//  Copyright © 2017 Victor Barcenas. All rights reserved.
//

import Foundation
import UIKit

struct Helpers {
    func newAlert(title:String,message:String)->UIAlertController{
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
        return alert
    }
    
    func errorAlert(error:Error)->UIAlertController{
        let errorAlert:UIAlertController = newAlert(title: "Error", message: error.localizedDescription)
        return errorAlert
    }
    
    func networkError()->UIAlertController{
        let message = "There's no internet connection"
        let title = "Error"
        let alert:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alert
    }
}
