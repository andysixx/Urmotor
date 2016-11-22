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

class RegisterViewController: UIViewController,UITableViewDataSource,FBSDKLoginButtonDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var Create_account: UIButton!
    @IBOutlet weak var loginButton: FBSDKLoginButton!
        override func viewDidLoad() {
        super.viewDidLoad()
            self.myTableView.isScrollEnabled = false
            FIRAuth.auth()?.addStateDidChangeListener { auth, user in
                if user != nil {
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
    
    func handleRegister(){
        
    
    
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{return 6}
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_TableViewCell", for: indexPath) as! Register_TableViewCell
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_TableViewCell_1", for: indexPath) as! Register_TableViewCell_1
            cell.configure(text: "", placeholder: "請輸入電子郵件")
            cell.email_text.tag = indexPath.row
            //set the data here
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_TableViewCell_1", for: indexPath) as! Register_TableViewCell_1
            cell.configure(text: "", placeholder: "請輸入密碼")
            cell.email_text.tag = indexPath.row
            //set the data here
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_TableViewCell_1", for: indexPath) as! Register_TableViewCell_1
            cell.configure(text: "", placeholder: "請確認密碼")
            cell.email_text.tag = indexPath.row
            //set the data here
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_TableViewCell_1", for: indexPath) as! Register_TableViewCell_1
            cell.configure(text: "", placeholder: "請輸入用戶名稱")
            cell.email_text.tag = indexPath.row
            //set the data here
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Register_TableViewCell_1", for: indexPath) as! Register_TableViewCell_1
            cell.configure(text: "", placeholder: "請輸入性別")
            cell.email_text.tag = indexPath.row
            //set the data here
            return cell
        }
    
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {

        self.loginButton.isHidden = true
        if(error != nil)
        {
            print(error.localizedDescription)
            self.loginButton.isHidden = false
        }
        else if (result.isCancelled)
        {
            self.loginButton.isHidden = false
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
                                _ = profilePicRef.put(imageData as Data, metadata: nil){
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
                                databaseRef.child("user_profile").child("\(user!.uid)/driver_mode").setValue(false)
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
