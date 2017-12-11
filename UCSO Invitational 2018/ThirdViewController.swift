//
//  ThirdViewController.swift
//  UCSO Invitational 2018
//
//  Created by Jung-Sun Yi-Tsang on 12/10/17.
//  Copyright © 2017 bayser. All rights reserved.
//

import Foundation
import WebKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView!
    @IBAction func backFunc(_ sender: Any) {
        webview.goBack()
    }
    
    @IBAction func forwardFunc(_ sender: Any) {
        webview.goForward()
    }
    
    @IBAction func refreshFunc(_ sender: Any) {
        webview.reload()
    }
    
    @IBAction func leaveFunc(_ sender: Any) {
        UIApplication.shared.open(webview.url!)
    }
    
    /*
    @IBAction func leaveFunc(_ sender: Any) {
        let url = webview.url
        UIApplication.shared.openURL(url!)
    } */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://www.ezratech.us/competition/university-of-chicago-science-olympiad-tournament")
        let request = URLRequest(url: url!)
        webview.load(request)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
