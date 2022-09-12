//
//  WebViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 05/09/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: urlString) else {return}
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.showSpinner()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.removeSpinner()
    }

}
