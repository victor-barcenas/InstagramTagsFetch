//
//  RESTClientDelegate.swift
//  RBI
//
//  Created by Victor Alfonso Barcenas Monreal on 17/10/16.
//  Copyright © 2016 Softtek. All rights reserved.
//

import Foundation

protocol RESTClientDelegate{
    func successWithArray(response: Array<AnyObject>, service:ServiceType)
    func successWithDictionary(response: Dictionary<String, AnyObject>, service:ServiceType)
    func errorWithNSError(error:Error)
}

enum ServiceType{
    case None
    case GetMediaByTag
}
