//
//  OpenLinkVC.swift
//  AutoFurnish
//
//  Created by Tutist Dev on 22/12/18.
//  Copyright © 2018 tutist. All rights reserved.
//

import UIKit

class OpenLinkVC: UIViewController {

    var url:URL?
    var HUD = MBProgressHUD()
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView.delegate = self
        if let url = url {
            let request = URLRequest(url: url)
            self.webView.loadRequest(request)
        }
        HUD = MBProgressHUD(view: self.webView)
        self.webView.addSubview(HUD)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension OpenLinkVC:UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.HUD.show(animated: true)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.HUD.hide(animated: true)
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Unable to loaD:\(error.localizedDescription)")
    }
}
