//
//  ViewController.swift
//  te
//
//  Created by SIX on 2016/5/18.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
//import <FBSDKCoreKit/FBSDKCoreKit.h>
//import <FBSDKLoginKit/FBSDKLoginKit.h>
import SafariServices
import LocalAuthentication
import Social
import MapKit
import FBSDKCoreKit
import FBSDKLoginKit
class ViewController: UIViewController,FBSDKLoginButtonDelegate{

   
//    
    let LoginBotton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
   
   @IBOutlet weak var logButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if(FBSDKAccessToken.current() == nil)
//        {
//            print("user is not login")
//        }
//        else{
//            print("user is loging")
//        }
//        view.addSubview(LoginBotton)
//        LoginBotton.center = view.center
//        LoginBotton.delegate = self
        logButton.delegate = self
        logButton.readPermissions = ["public_profile","email","user_friends"]
       
//        // Do any additional setup after loading the view, typically from a nib.
//        if let token = FBSDKAccessToken.current(){
//            fectchProfile()
//        }
    }
//    func fectchProfile(){
//        print("fectchProfile")
//        let parameters = ["fields":"email,first_name,last_name,picture.type(large)"]
//        FBSDKGraphRequest(graphPath:"me",parameters: parameters).start{(connection,result,error)-> Void in
//        if error != nil{
//            print(error)
//            return
//        }
//        if let email = result ["email"] as String{
//            print(email)
//        
//        }
//     }
//        
        public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
        {
    
            if(error != nil)
                    {
                        print(error.localizedDescription)
                        return
                    }
                    if let userToken = result.token
            
                    {
                        let token : FBSDKAccessToken = result.token
                        print("Token =\(FBSDKAccessToken.current().tokenString)")
                        print("User ID =\(FBSDKAccessToken.current().userID)")
                        let revealViewControl = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = revealViewControl
                        
                    }

        }
        
        
        public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
        {}

//    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        print("complete loggin")
//        fectchProfile()
//        if(error != nil)
//        {
//            print(error.localizedDescription)
//            return
//        }
//        if let userToken = result.token
//      
//        {
//            let token : FBSDKAccessToken = result.token
//            print("Token =\(FBSDKAccessToken.current().tokenString)")
//            print("User ID =\(FBSDKAccessToken.current().userID)")
//            let revealViewControl = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = revealViewControl
//            
//        }
//    }
//    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        print("user is logged out")
//    }
//    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
//        return true
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @implementation ViewController
//    
//    - (void)viewDidLoad {
//    [super viewDidLoad];
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    // Optional: Place the button in the center of your view.
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
//    }
    }


