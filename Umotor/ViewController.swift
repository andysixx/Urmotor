//
//  ViewController.swift
//  te
//
//  Created by SIX on 2016/5/18.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
class ViewController: UIViewController,FBSDKLoginButtonDelegate{
   
   
    @IBOutlet weak var LoginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        LoginButton.delegate = self
        LoginButton.readPermissions = ["public_profile","email","user_friends"]
    }
//    func fectchProfile(){
//        print("fectchProfile")
//        let parameters = ["fields":"email,first_name,last_name,picture.type(large)"]
//        FBSDKGraphRequest(graphPath:"me",parameters: parameters).start(completionHandler: (connection, result, error)-> Void in
//            if error != nil{
//            print(error)
//            }
//            if let email = result ["email"] as? String{
//            print(email)
//            }
//            if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as NSDictionary, let url = data["url"] as? String{
//                print(url)
//            }
//            
//        }
//     }
        
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
            let revealViewControl1 = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
            appDelegate1.window?.rootViewController = revealViewControl1
            
        }
        
        
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
    
    
    
    }


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


