//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Alexio Mota on 5/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "https://www.bignerdranch.com")
        let request = NSURLRequest(URL: url!)
        webView?.loadRequest(request)
    }
}
