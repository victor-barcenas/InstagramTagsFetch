//
//  RESTClient.swift
//  RBI
//
//  Created by Victor Alfonso Barcenas Monreal on 17/10/16.
//  Copyright © 2016 Softtek. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class RESTClient{
    
    private var sessionManager:Alamofire.SessionManager
    var networkManager:Alamofire.NetworkReachabilityManager
    private var activityIndicator:ActivityIndicatorView?
    
    init(){
        self.activityIndicator = ActivityIndicatorView(title: "", center: CGPoint(x: 0, y: 0))
        self.sessionManager = SessionManager()
        self.sessionManager.session.configuration.timeoutIntervalForRequest = 30
        self.networkManager = Alamofire.NetworkReachabilityManager()!
        networkManager.startListening()
    }
    
    private func showActivityIndicator(sender:UIViewController, message:String){
        self.activityIndicator = ActivityIndicatorView(title: message, center: sender.view.center)
        sender.view.addSubview(self.activityIndicator!.getViewActivityIndicator())
        self.activityIndicator?.startAnimating()
    }
    
    private func hideActivityIndicator(){
        self.activityIndicator?.stopAnimating()
    }
    
    private func networkError()->NSError{
        self.networkManager.stopListening()
        return NSError(domain: "NetworkError", code: 0, userInfo: nil)
    }
    
    private func customError(message:String, domain:String,code:Int)->NSError{
        self.networkManager.stopListening()
        return NSError(domain: domain, code: code, userInfo: [domain:message])
    }
    
    private func responseHandler(response:Result<Any>, delegate:RESTClientDelegate, service:ServiceType){
        if response.value != nil {
            let isDictionary = response.value is Dictionary<String,AnyObject>
            var JSON:AnyObject = "" as AnyObject
            if  isDictionary {
                JSON = response.value! as AnyObject
                delegate.successWithDictionary(response: JSON as! Dictionary<String, AnyObject>, service: service)
            }else{
                JSON = response.value! as AnyObject
                delegate.successWithArray(response: JSON as! Array<AnyObject>, service: service)
            }
            
        }
    }
    
    func GET(sender:UIViewController, url:String, delegate:RESTClientDelegate, service:ServiceType){
        if networkManager.isReachable {
            showActivityIndicator(sender: sender, message: "Loading")
            sessionManager.request(url).responseJSON { response in
                self.hideActivityIndicator()
                if (response.result.isFailure){
                    delegate.errorWithNSError(error: response.result.error!)
                }else{
                    self.responseHandler(response: response.result, delegate: delegate, service: service)
                }
            }
        }else{
            hideActivityIndicator()
            let alert = Helpers().newAlert(title: Constants.Strings.errorTitle, message: Constants.Strings.networkError)
            sender.present(alert, animated: true, completion: nil)
        }
    }
    
    func POST(sender:UIViewController, params:Dictionary<String,AnyObject>, url:String, delegate:RESTClientDelegate, service:ServiceType){
        if networkManager.isReachable {
            showActivityIndicator(sender: sender, message: "Loading")
            sessionManager.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: [:]).responseJSON{ response in
                self.hideActivityIndicator()
                if (response.result.isFailure){
                    delegate.errorWithNSError(error: response.result.error!)
                }else{
                    self.responseHandler(response: response.result, delegate: delegate, service: service)
                }
            }
        }else{
            hideActivityIndicator()
            let alert = Helpers().newAlert(title: Constants.Strings.errorTitle, message: Constants.Strings.networkError)
            sender.present(alert, animated: true, completion: nil)
        }
    }
}



















