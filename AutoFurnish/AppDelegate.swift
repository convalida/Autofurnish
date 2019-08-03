//
//  AppDelegate.swift
//  AutoFurnish
//
//  Created by rajat on 01/07/18.
//  Copyright © 2018 tutist. All rights reserved.
//

import UIKit

///Default class with pre defined life cycle methods of application.
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /**
     Windows work with your view controllers to handle events and to perform many other tasks that are fundamental to your app’s operation. UIKit handles most window-related interactions, working with other objects as needed to implement many app behaviors.
     */
    var window: UIWindow?

/**
 Called when application is launched for first time. Override point for customization after application launch. Tells the delegate that the launch process is almost done and the app is almost ready to run.
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //    UIColor.init(red: 5, green: 46, blue: 69, alpha: 1.0)
        return true
    }

    /**
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
     */
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

  /**  Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 */
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    /**
 Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     */
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background. Display in logs that the app entered foreground
        print("App Entered Foreground")
    }

    /**
 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    /**
 Called when the application is about to terminate. Save data if appropriate. 
     */
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

