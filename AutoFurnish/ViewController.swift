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
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        if #available(iOS 10.0, *) {
            webConfiguration.dataDetectorTypes = [.all]
        } else {
            // Fallback on earlier versions
        }
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://www.autofurnish.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        webView.allowsBackForwardNavigationGestures = true
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
        
        switch navigationAction.request.url?.scheme {
        case "mailto"?:
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
        default:
            decisionHandler(.allow)
        }
      
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url, let host = url.host, !host.hasPrefix("www.autofurnish.com") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(navigationAction.request.url!, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else{
                //decisionHandler(.allow)
            }
        }
    }
    
    
    func showNotReachableAlert(){
        let notReachableAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        notReachableAlert.addAction(okAction)
//        DispatchQueue.function()
        present(notReachableAlert, animated: true, completion: nil)
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
