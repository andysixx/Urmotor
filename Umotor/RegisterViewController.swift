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
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController,FBSDKLoginButtonDelegate {

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
                }
            }
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
                
                if(error == nil){
                    let storage = FIRStorage.storage()
                    
                    let storageRef = storage.reference(forURL: "gs://umotor-7f3dd.appspot.com")
                    let profilePicRef = storageRef.child(user!.uid + "profile_pic_small.jpg")
                    
                    
                    //store the user ID
                    let userID = user?.uid
                    let databaseRef = FIRDatabase.database().reference()
                    databaseRef.child("user_profile").child(userID!).child("profile_pic_small").observeSingleEvent(of: .value, with: {(snapshot) in
                        print(snapshot)
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
                            
                            databaseRef.child("user_profile").child("\(user!.uid)/name").setValue(user?.displayName)
                            databaseRef.child("user_profile").child("\(user!.uid)/age").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/phone").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/gender").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/school_area").setValue("")
                            databaseRef.child("user_profile").child("\(user!.uid)/email").setValue(user?.email)
                                databaseRef.child("user_profile").child("\(user!.uid)/friends").setValue("")
                                databaseRef.child("user_profile").child("\(user!.uid)/driver_mode").setValue("")
                            } 
                        }else{
                            print("User has logged in earlier")
                        }
                        
                    })
                    
                    
                    
                }
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
