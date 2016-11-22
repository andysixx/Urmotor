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
import FirebaseMessaging
import NotificationCenter
import FirebaseInstanceID
import UserNotifications
import UserNotificationsUI
import AirshipKit
import KumulosSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate,FIRMessagingDelegate {

    var window: UIWindow?

    let googleMapsApiKey = "AIzaSyBduCywvCVQYrqQhiWWDSG5elyhE-SZFys"
    
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        _ = Pushbots(appId:"58315b264a9efa3f088b4567", prompt: true)
//        if Platform.isSimulator {
//            // Do one thing
//            print("isSimulator")
//        }
//        else {
            Kumulos.initialize("30ef3730-4f04-4af0-9ea0-075bff8d9e97", secretKey: "PWBUrPNazvdbXsFWE06azJw/0J//yUXT5HXf")
            let installId = Kumulos.installId
            print("installId: \(installId)")
            Kumulos.pushRequestDeviceToken()
//
//           
//        }

        
        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                //Capture notification data e.g. badge, alert and sound
                if let aps = userInfo["aps"] as? NSDictionary {
                    let alert = aps["alert"] as! String
                    print("Notification message: ", alert);
                    //UIAlertView(title:"Push Notification!", message:alert, delegate:nil, cancelButtonTitle:"OK").show()
                }
                
                //Capture custom fields
                if let articleId = userInfo["articleId"] as? NSString {
                    print("ArticleId: ", articleId);
                }
            }
        }
        GMSServices.provideAPIKey(googleMapsApiKey)
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if application.applicationState == .inactive  {
            Pushbots.sharedInstance().trackPushNotificationOpened(withPayload: userInfo);
        }
        
        //The application was already active when the user got the notification, just show an alert.
        //That should *not* be considered open from Push.
//        if application.applicationState == .active  {
//            //Capture notification data e.g. badge, alert and sound
//            if let aps = userInfo["aps"] as? NSDictionary {
//                let alert_message = aps["alert"] as! String
//                let alert = UIAlertController(title: "Push Notification!",
//                                              message: alert_message,
//                                              preferredStyle: .alert)
//                let defaultButton = UIAlertAction(title: "OK",
//                                                  style: .default) {(_) in
//                                                    // your defaultButton action goes here
//                }
//                
//                alert.addAction(defaultButton)
//                self.window?.rootViewController?.present(alert, animated: true) {
//                    // completion goes here
//                }
//            }
//        }
    }
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage){
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
//  public  func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
//        // Print notification payload data
//        print("Push notification received: \(data)")
//    }
//    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")

        Kumulos.pushRegister(deviceToken)
        Pushbots.sharedInstance().register(onPushbots: deviceToken)
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification Registration Error \(error)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        FIRMessaging.messaging().disconnect()
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
//        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
//    func tokenRefreshNotification(_ notification: Notification) {
//        if let refreshedToken = FIRInstanceID.instanceID().token() {
//            print("InstanceID token: \(refreshedToken)")
//        }
//        
//        // Connect to FCM since connection may have failed when attempted before having a token.
//        connectToFCM()
//    }
    
//    
//    func connectToFCM(){
//        FIRMessaging.messaging().connect{(error) in
//            if(error != nil){
//                print("Unable to connect to FCM \(error.debugDescription)")
//            }else{
//                print("Connected to FCM")
//            }
//        }
//    }

}


