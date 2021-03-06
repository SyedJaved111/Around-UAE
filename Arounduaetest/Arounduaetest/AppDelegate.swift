//
//  AppDelegate.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // status bar set
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red:241/255, green:242/255, blue:243/255, alpha: 1)
        }
        
        IQKeyboardManager.sharedManager().enable = true
        GMSPlacesClient.provideAPIKey("AIzaSyBeblugMSfJeJtTRFB6lFGxejNtxBcVW_I")
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "726253961199-7djm89dcuppkndauve0pevkmlfmrimaf.apps.googleusercontent.com"
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    func moveToHome(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let logINN = storyboard.instantiateViewController(withIdentifier: "VCHomeTabs") as! VCHomeTabs
        let nvc: UINavigationController = UINavigationController(rootViewController: logINN)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    
    func moveToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCLogin") as! VCLogin
        vc.ishownBackBtn = false
        let nvc: UINavigationController = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    
    func moveToSplash(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logINN = storyboard.instantiateViewController(withIdentifier: "VCSplash") as! VCSplash
        let nvc: UINavigationController = UINavigationController(rootViewController: logINN)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
    
    func moveToSelectlanguage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let logINN = storyboard.instantiateViewController(withIdentifier: "VCSelectLanguage") as! VCSelectLanguage
        let nvc: UINavigationController = UINavigationController(rootViewController: logINN)
        self.window?.rootViewController = nvc
        self.window?.makeKeyAndVisible()
    }
}

