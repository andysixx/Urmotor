//
//  ViewControllerSec.swift
//  Umotor
//
//  Created by SIX on 2016/10/12.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import  FirebaseAuth

class ViewControllerSec: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var user_passwordch: UITextField!
    @IBOutlet weak var user_password: UITextField!
    @IBOutlet weak var user_id: UITextField!
    @IBOutlet weak var theTitle: UILabel!
    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var orLB: UILabel!
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
                    self.loginButton.readPermissions = ["public_profile","email","user_friends"]
                    self.loginButton.delegate = self
                    self.view!.addSubview(self.loginButton)
                    
                    //                self.LoginButton.isHidden = false
                    
                }
            }
//        loginButton.delegate = self
//        loginButton.readPermissions = ["public_profile","email","user_friends"]
        // Do any additional setup after loading the view.
    }

    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        user_passwordch.isHidden = true
        user_id.isHidden = true
        user_password.isHidden = true
        theTitle.isHidden = true
        createButton.isHidden = true
        orLB.isHidden = true
        self.loginButton.isHidden = true
        aivLoadingSpinner.startAnimating()
        if(error != nil)
        {
            print(error.localizedDescription)
            self.loginButton.isHidden = false
            aivLoadingSpinner.stopAnimating()
        }
        else if (result.isCancelled)
        {
            self.loginButton.isHidden = false
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


    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
