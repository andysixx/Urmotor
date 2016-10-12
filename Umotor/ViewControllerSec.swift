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

class ViewControllerSec: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
        override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        // Do any additional setup after loading the view.
    }

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
