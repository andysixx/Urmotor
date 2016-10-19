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
import FirebaseStorage
import FirebaseDatabase
class LoginViewController: UIViewController,FBSDKLoginButtonDelegate{
   
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
            }
        
        
        }
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
                if(error == nil){
                    let storage = FIRStorage.storage()
                
                    let storageRef = storage.reference(forURL: "gs://umotor-68385.appspot.com")
                    let profilePicRef = storageRef.child(user!.uid + "profile_pic_small.jpg")
                    
                    
                    //store the user ID
                    let userID = user?.uid
                    let databaseRef = FIRDatabase.database().reference()
                    databaseRef.child("user_profile").child("profile_pic_small").observeSingleEvent(of: .value, with: {(snapshot) in
                        let profilePic = snapshot.value as? String?
                        
                        if(profilePic == nil){
                            if let imageData = NSData(contentsOf: user!.photoURL!){
                                let uploadTask = profilePicRef.put(imageData as Data, metadata: nil){
                                    metadata,error in
                                    if(error == nil){
                                    
                                        let DownloadUrl = metadata!.downloadURL
                                        databaseRef.child("user_profile").child("\(user!.uid)/profile_pic_small").setValue(DownloadUrl()!.absoluteString)
                                    
                                    }
                                    else{
                                        
                                        
                                        print("error in download image")
                                    
                                    }
                                }
                            }
                            databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                            databaseRef.child("user_profile").child("\(user!.uid)/age").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/phone").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/gender").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/school_area").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user?.email)
                            databaseRef.child("user_profile").child("\(user!.uid)/friends").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/driver_mode").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/call_motor").setValue("")
                        }else{
                            print("User has logged in earlier")
                        }
                    
                    })
                    
                    
                
                }
            }
        }
        
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
