//
//  WebViewViewController.swift
//  Toruński Przewodnik
//
//  Created by Arkadiusz Stasczak on 29.10.2018.
//  Copyright © 2018 Arkadiusz Staśczak. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    var urlPath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let urlToOpen = URL(string: urlPath) {
            let myRequest = URLRequest(url: urlToOpen)
            webView.load(myRequest)
        }
    }

}
