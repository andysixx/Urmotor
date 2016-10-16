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
import FirebaseAuth
import AVKit
import AVFoundation
class ViewController: UIViewController,FBSDKLoginButtonDelegate{
   
    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
   
    @IBOutlet weak var LoginButton: FBSDKLoginButton!
  
    @IBOutlet weak var user_id_field: UITextField!
    @IBOutlet weak var user_password_field: UITextField!
    @IBOutlet weak var LAB: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                // Move to user view
                let mainstoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                let homeviewcontroller: UIViewController = mainstoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")
                self.present(homeviewcontroller, animated: true, completion: nil)
            }
            else{
            // No user is signed in.
                self.LoginButton.readPermissions = ["public_profile","email","user_friends"]
                self.LoginButton.delegate = self
                self.view!.addSubview(self.LoginButton)
                
//                self.LoginButton.isHidden = false
            
            }
        
        
        }

//        fetchProfile()
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        user_id_field.isHidden = true
        user_password_field.isHidden = true
        LAB.isHidden = true
        self.LoginButton.isHidden = true
        aivLoadingSpinner.startAnimating()
        if(error != nil)
        {
            print(error.localizedDescription)
            self.LoginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else if (result.isCancelled)
        {
            self.LoginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else
        {
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                // ...
                print("user logged in Firebase App")
            }
        }
//        if let userToken = result.token
//            
//        {
//            let token : FBSDKAccessToken = result.token
//            print("Token =\(FBSDKAccessToken.current().tokenString)")
//            print("User ID =\(FBSDKAccessToken.current().userID)")
////            let revealViewControl1 = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
////            let appDelegate1 = UIApplication.shared.delegate as! AppDelegate
////            appDelegate1.window?.rootViewController = revealViewControl1
//            let mainstoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
//            let homeviewcontroller: UIViewController = mainstoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")
//            self.present(homeviewcontroller, animated: true, completion: nil)
//            
//        }
//
        
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
    
    
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//

}


//    FBSDKGraphRequest(graphPath:"me",parameters: parameters).start(completionHandler: (connection, result, error)-> Void in
//            if error != nil{
//            print("Error: \(error)")
//            }
//            if let email = result ["email"] as? String{
//            print(email)
//            }
//            if let picture = result["picture"] as? NSDictionary, let data = picture["data"] as NSDictionary, let url = data["url"] as? String{
//                print(url)
//            }
