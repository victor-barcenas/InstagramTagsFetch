//
//  ViewController.swift
//  InstaTag
//
//  Created by Victor Alfonso Barcenas Monreal on 02/02/17.
//  Copyright © 2017 Victor Barcenas. All rights reserved.
//

import UIKit
import Foundation

class Login: UIViewController {
    
    private var webView:UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        webView = UIWebView(frame: self.view.bounds)
        webView.delegate = self
        let oAuth = URL(string: Constants.Instagram.oAuth)
        let request = URLRequest(url: oAuth!)
        webView.loadRequest(request)
        self.view.addSubview(webView)
    }
}

extension Login:UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.absoluteString.range(of:"#") != nil{
            let token = (request.url?.absoluteString)!.components(separatedBy: "=")[1]
            print(token)
            UserDefaults.standard.set(token, forKey: "accesToken")
            self.performSegue(withIdentifier: "home", sender: self)
        }
        return true
    }
}

