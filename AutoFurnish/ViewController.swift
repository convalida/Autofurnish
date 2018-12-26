//
//  ViewController.swift
//  AutoFurnish
//
//  Created by rajat on 01/07/18.
//  Copyright © 2018 tutist. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class ViewController: UIViewController {

    var webView: WKWebView!
    @IBOutlet weak var viewWeb: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var splashView: UIView!
    
    var isFirstTimeLoad:Bool = true
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        if #available(iOS 10.0, *) {
            webConfiguration.dataDetectorTypes = [.all]
        } else {
            // Fallback on earlier versions
        }
        
        let viewFrame = CGRect(x: 0, y: 0, width: viewWeb.frame.width, height: viewWeb.frame.height)
        
        webView = WKWebView(frame: viewFrame, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.viewWeb.insertSubview(webView, at: 0)
        
        let horConstraint = NSLayoutConstraint(item: webView, attribute: .centerX, relatedBy: .equal,
                                               toItem: viewWeb, attribute: .centerX,
                                               multiplier: 1.0, constant: 0.0)
        let verConstraint = NSLayoutConstraint(item: webView, attribute: .centerY, relatedBy: .equal,
                                               toItem: viewWeb, attribute: .centerY,
                                               multiplier: 1.0, constant: 0.0)
        let widConstraint = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal,
                                               toItem: viewWeb, attribute: .width,
                                               multiplier: 1.0, constant: 0.0)
        let heiConstraint = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal,
                                               toItem: viewWeb, attribute: .height,
                                               multiplier: 1.0, constant: 0.0)

        view.addConstraints([horConstraint, verConstraint, widConstraint, heiConstraint])
        
        loadHomeUrl()
        
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1"
        
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            DispatchQueue.main.async {
//                self.webView.frame.size = self.viewWeb.frame.size
//            }
//        } else {
//            print("Portrait")
//            DispatchQueue.main.async {
//                self.webView.frame.size = self.viewWeb.frame.size
//            }
//        }
//    }
    
    func loadHomeUrl(){
        let myURL = URL(string:"https://www.autofurnish.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: WKNavigationDelegate {
    // Gets called if webView cant handle URL
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let reachability = Reachability.init() {
            if  !reachability.isReachable {
                self.showNotReachableAlert();
                decisionHandler(.cancel)
                return
            }
        }
        
        if navigationAction.request.url?.scheme == "mailto" {
            if let url = navigationAction.request.url {
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false){
                    let email = components.path
                    print(email)
                    let mailComposeViewController = configuredMailComposeViewController(email: email)
                    if MFMailComposeViewController.canSendMail() {
                        self.present(mailComposeViewController, animated: true, completion: nil)
                    } else {
                        self.showSendMailErrorAlert()
                    }
                }
            }
            
            decisionHandler(.cancel)
            return
        }
      
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, let host = url.host
                 {
                    if (host.range(of: "www.convalidatech.com") != nil || host.range(of: "twitter.com") != nil || host.range(of: "plus.google.com") != nil || host.range(of: "www.instagram.com") != nil || host.range(of: "www.youtube.com") != nil || host.range(of: "play.google.com") != nil || host.range(of: "itunes.apple.com") != nil) {
                        loadUrl(url: url)
                    } else if host.range(of: "www.facebook.com") != nil {
                        let myRequest = URLRequest(url: url)
                        webView.load(myRequest)
                    }
            } else {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isFirstTimeLoad == true {
            splashView.removeFromSuperview();
            isFirstTimeLoad = false //set to false if a page is loaded
        }
        print("loaded")
    }
    
    func showNotReachableAlert(){
        let notReachableAlert = UIAlertController(title: "Internet connection is required", message: "Please check your internet connection and try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Retry", style: .default) { (action) in
            if self.isFirstTimeLoad {
                if let reachability = Reachability.init() {
                    if  !reachability.isReachable {
                        self.showNotReachableAlert();
                    } else {
                        self.loadHomeUrl()
                    }
                }
            } else {
                self.webView.reload();
            }
        }
        notReachableAlert.addAction(okAction)
        present(notReachableAlert, animated: true, completion: nil)
    }
    
    /**
     Loads a url
    */
    func loadUrl(url:URL){
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension ViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController(email:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        sendMailErrorAlert.addAction(okAction)
        
        sendMailErrorAlert.show(self, sender: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: WKUIDelegate {
    
}
