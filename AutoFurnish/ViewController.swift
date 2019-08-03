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

///Root view controller class for displaying web view.
class ViewController: UIViewController {

    ///Instantiate WKWebView which is pre defined class for displaying web content
    var webView: WKWebView!
    
    /**
     Instantiate outlet for UIView class which is pre defined class which manages content for rectangular are on screen
     */
    @IBOutlet weak var viewWeb: UIView!
    ///Outlet for logo on splash screen.
    @IBOutlet weak var imgLogo: UIImageView!
    ///Outlet for splash screen.
    @IBOutlet weak var splashView: UIView!
    
    ///Boolean to check if home page is loaded for first time.
    var isFirstTimeLoad:Bool = true
    
    ///Display status bar
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    ///Set style of status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    /**
     Life cycle method called after view is loaded.
     Initialize WKWebViewConfiguration() which is pre defined class for collection of properties used to initialize a web view.
     For iOS versions 10 and above, set data detection to add interactivity to web content to all data types turned into links when detected.
     Set width and height of web view to width and height of superview.
     Set webview with with frame and configuration of webview, user interface and navigation delegate to self.
     Set auto resizing mask not translated into AutoLayout constraints, then insert web view as sub view.
     Set horizontal, vertical, width and height constraint of web view and add the constraints.
     Load home page url of autofurnish website.
     Set custom user agent to web view.
     Add horizontal swipe gestures will trigger back-forward list navigations
     */
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
    
    /**
     Called before the view is loaded. Hide the navigation bar
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /**
     Called when the view is about to disappear. Display navigation bar. We are using NavigationViewController so Navigation Bar is set to hidden for webview.
     */
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
    
    /**
     Load autofurnish web url inside webview
     */
    func loadHomeUrl(){
        let myURL = URL(string:"https://www.autofurnish.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

     /// Dispose off any resources that can be recreated.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController: WKNavigationDelegate {
    /**
     Gets called if webView cannot handle URL.
     Show alert displaying internet connection is required using Reachability class. This alert has a retry button for user to retry loading the page when internet connection is available
     If url has "mailto" text then we display a mail composer to user. Call configuredMailComposeViewController method and pass the email. If current device can send email, then display mail controller else show alert with message and cancel button.
     If link is with href url, if url is navigation request url, and navigation url is google plus, youtube, etc., then open link in appropriate app, if navigation url is facebook, load request that is independent of protocol or URL scheme (to resolve an issue) else set decision handler to allow
     */
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
    
    /**
     Called when the navigation is complete. If webview is loaded for first time, remove splash screen and set isFirstTimeLoaded to false. Print loaded in logs
     */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if isFirstTimeLoad == true {
            splashView.removeFromSuperview();
            isFirstTimeLoad = false //set to false if a page is loaded
        }
        print("loaded")
    }
    
    /**
     Set title and message to alert to be displayed if internet is not connected to device with retry button. If webview is loaded for first time, display alert, else load url for home page. If it is not first time then the current page is reloaded again, on click of retry button when internet is turned on
     */
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
     Loads a url. If the specified URL scheme is handled by another app, iOS launches that app and passes the URL to it. openURL was deprecated in iOS 10, so open method is used
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
    /**
     Display a standard interface for managing, editing, and sending an email message.
     Set mail composition view controller’s delegate to self. Set the initial recipients to include in the email’s “To” field to email id passed in link
     */
    func configuredMailComposeViewController(email:String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([email])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    /**
     Message to be displayed in alert if email could not be sent from device with ok button
     */
    func showSendMailErrorAlert() {
        
       
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        sendMailErrorAlert.addAction(okAction)
        
        sendMailErrorAlert.show(self, sender: nil)
    }
    
    /**
     MFMailComposeViewControllerDelegate method. When the mail composition interface is dismissed, dismiss the controller for mail.
     */
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: WKUIDelegate {
    
}
