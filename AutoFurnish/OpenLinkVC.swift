//
//  OpenLinkVC.swift
//  AutoFurnish
//
//  Created by Tutist Dev on 22/12/18.
//  Copyright © 2018 tutist. All rights reserved.
//

import UIKit

///Not used. 
class OpenLinkVC: UIViewController {

    ///Instantiate url
    var url:URL?
    
    ///Instantiate hud view
    var HUD = MBProgressHUD()
    
    ///Outlet for webview
    @IBOutlet weak var webView: UIWebView!
    
    /**
     Life cycle method called after view is loaded.
     Set delegate of web view to self. Not used
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         Do any additional setup after loading the view. Load url to web view. Add hud view as sub view of web view.
         */
        self.webView.delegate = self
        if let url = url {
            let request = URLRequest(url: url)
            self.webView.loadRequest(request)
        }
        HUD = MBProgressHUD(view: self.webView)
        self.webView.addSubview(HUD)
    }
    
    /**
     Called before the view is loaded, display navigation bar, not used
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

extension OpenLinkVC:UIWebViewDelegate {
    /**
     Sent after a web view starts loading a frame. Show hud view. Not used. Not used
     */
    func webViewDidStartLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.HUD.show(animated: true)
        }
    }
    
    /**
     Sent after a web view finishes loading a frame. Hide the hud view. Not used
     */
    func webViewDidFinishLoad(_ webView: UIWebView) {
        DispatchQueue.main.async {
            self.HUD.hide(animated: true)
        }
    }
    
    /**
     Sent if a web view failed to load a frame. Display message in logs. Not used
     */
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Unable to loaD:\(error.localizedDescription)")
    }
}
