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
import GooglePlaces
import Firebase
import NotificationCenter
import UserNotifications
import UserNotificationsUI
import FirebaseAuth
import KumulosSDK
import PushKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    

    let googleMapsApiKey = "AIzaSyBduCywvCVQYrqQhiWWDSG5elyhE-SZFys"
     let deviceID = UIDevice.current.identifierForVendor?.uuidString
    
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

        Fabric.with([Crashlytics.self])
        Kumulos.pushRequestDeviceToken()
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self

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
        GMSServices.provideAPIKey(googleMapsApiKey)
        
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
        Kumulos.initialize("30ef3730-4f04-4af0-9ea0-075bff8d9e97", secretKey: "PWBUrPNazvdbXsFWE06azJw/0J//yUXT5HXf")
        let installId = Kumulos.installId
                    print("installId: \(installId)")
         Kumulos.pushRequestDeviceToken()
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        print("123")
    }
   
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if application.applicationState == .inactive || application.applicationState == .background {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = self.window?.rootViewController as? UINavigationController
            let destinationController = storyboard.instantiateViewController(withIdentifier: "Credit_Driver_TableViewController") as? Credit_Driver_TableViewController
            navigationController?.pushViewController(destinationController!, animated: false)
            let destinationController2 = storyboard.instantiateViewController(withIdentifier: "Ordertable_TableViewController") as? Ordertable_TableViewController
            navigationController?.pushViewController(destinationController2!, animated: false)
        }
    }
    // iOS9
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       print(userInfo)
        if (UIApplication.shared.applicationState == UIApplicationState.inactive) {
            Kumulos.pushTrackOpen(notification: userInfo)
        }
        completionHandler(UIBackgroundFetchResult.noData)
    }
    
    // iOS10
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .sound, .alert])
        // 彼得潘測試
    }
    
    // iOS10
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo;
        Kumulos.pushTrackOpen(notification: userInfo)
        completionHandler()
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
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        // Print it to console
        print("APNs device token: \(deviceTokenString)")

        Kumulos.pushRegister(deviceToken)

        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Notification Registration Error \(error)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let Fauth = FIRAuth.auth()?.currentUser
        if Fauth != nil{
            print("login print")
            let myConnectionsRef = FIRDatabase.database().reference(withPath: "user_profile/\(Fauth!.uid)/connection/\(self.deviceID!)")
            myConnectionsRef.child("online").setValue(false)
            myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        }
        else{
        
            print("logout print")
        }
//        if ÷÷
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
    func applicationDidBecomeActive(_ application: UIApplication) {
       
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        let Fauth = FIRAuth.auth()?.currentUser
        if Fauth != nil{
            manageConnections(userID: (Fauth?.uid)!)
            print("login print")
            
        }
        else{
            
            print("logout print")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func manageConnections(userID: String){
        
        let myConnectionsRef = FIRDatabase.database().reference(withPath: "user_profile/\(userID)/connection/\(self.deviceID!)")
        //When the User logged in, set the value to true!
        myConnectionsRef.child("online").setValue(true)
        myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        myConnectionsRef.observe(.value, with: {snapshot in
            //Unlike an if statement, guard statements
            guard let connected = snapshot.value as? Bool, connected else{
                
                return
                
            }
        })
        
        
        
    }


}
