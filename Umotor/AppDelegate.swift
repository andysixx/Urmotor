//
//  AppDelegate.swift
//  te
//
//  Created by SIX on 2016/5/18.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleMaps
import Firebase
import MapKit
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?

    let googleMapsApiKey = "AIzaSyBduCywvCVQYrqQhiWWDSG5elyhE-SZFys"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      FIRApp.configure()
        
//        let notificationTypes : UIUserNotificationType = [UIUserNotificationType.alert,UIUserNotificationType.badge,UIUserNotificationType.sound]
//        let notificationSetting = UIUserNotificationSettings(types : notificationTypes, categories: nil)
//        application.registerForRemoteNotifications()
//        application.registerUserNotificationSettings(notificationSetting)
             // Override point for customization after application launch.
        GMSServices.provideAPIKey(googleMapsApiKey)
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("messageID: \(userInfo["gcm_message_ID"]!)")
//        print(userInfo)
//    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}


