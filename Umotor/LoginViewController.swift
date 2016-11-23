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
class LoginViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,FBSDKLoginButtonDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        self.TableViewCustom.selectRow(at: IndexPath(row: textField.tag , section:0), animated: false, scrollPosition: .none)
    }

   
    @IBOutlet weak var TableViewCustom: UITableView!
    @IBOutlet weak var aivLoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var LoginButton: FBSDKLoginButton!
    var email_text: String?
    var password_text: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableViewCustom.isScrollEnabled = false
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{return 4}
    func handleLogin(){
        var index = 1
        while index<3 {
            let indePath = IndexPath(row: index, section: 0)
            let cell: login_tableinput2TableViewCell? = self.TableViewCustom.cellForRow(at: indePath) as? login_tableinput2TableViewCell
            if index == 1{
                email_text = (cell?.textfiledCum.text)!
            }
            else if index == 2{
                password_text = (cell?.textfiledCum.text)!
            }
            index+=1

        }
        FIRAuth.auth()?.signIn(withEmail: email_text!, password: password_text!, completion: {(user, error) in
            if error != nil {
                print(error!)
                return
            }
            
        })
    
    
    
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "firstCustomCell", for: indexPath) as! Login_TableInputTableViewCell
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCustomCell", for: indexPath) as! login_tableinput2TableViewCell
            cell.configure(text: "", placeholder: "請輸入電子郵件")
            cell.textfiledCum.tag = indexPath.row
            //set the data here
            return cell
        }
        else if indexPath.row == 2 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "secondCustomCell", for: indexPath) as! login_tableinput2TableViewCell
            cell.configure(text: "", placeholder: "請輸入密碼")
            cell.textfiledCum.tag = indexPath.row
            //set the data here
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonveiwcell", for: indexPath) as! login_tableinput3TableViewCell
           cell.EmailloginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
            //set the data here
            return cell

        }
    }
       public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
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
                print("user logged in Firebase App")
                if(error == nil){
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference(forURL: "gs://umotor-7f3dd.appspot.com")
                    let profilePicRef = storageRef.child(user!.uid + "profile_pic_small.jpg")
                    let userID = user?.uid
                    let databaseRef = FIRDatabase.database().reference()
                    databaseRef.child("user_profile").child(userID!).child("profile_pic_small").observeSingleEvent(of: .value, with: {
                        (snapshot) in
                        var profilePic = snapshot.value as? String?
                        
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
                            databaseRef.child("user_profile").child("\(user!.uid)/driver_mode").setValue(false)
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
