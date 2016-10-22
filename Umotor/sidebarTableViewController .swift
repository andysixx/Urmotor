//
//  sidebarTableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/7/7.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import  FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class sidebarTableViewController: UITableViewController {
    @IBOutlet weak var User_profile_pic: UIImageView!
//    @IBOutlet weak var User_profile_pic: UIImageView!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var User_name: UILabel!
    var pickerVisible = false
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    override func viewDidLoad() {
       
        super.viewDidLoad()
//        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.tableView.separatorColor = UIColor.white
        self.view.layoutIfNeeded()
        self.User_profile_pic.layer.cornerRadius = self.User_profile_pic.frame.size.width/2
        self.User_profile_pic.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            User_name.text = "Hi!~"+name!
            
            
            manageConnections(userID: uid)
            
            let storage = FIRStorage.storage()
            
            let storageRef = storage.reference(forURL: "gs://umotor-7f3dd.appspot.com")
            let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"width":"300","redirect":false],httpMethod:"GET")
            
            
            let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    
                    print("Uable to download image")
                    
                    // Uh-oh, an error occurred!
                } else {
                    
                    
                    if(data != nil)
                    {
                        print("User already has an Image Not need to Download from facebook")
                        self.User_profile_pic.image = UIImage(data : data!)
                    }
                    
                    // Data for "images/island.jpg" is returned
                    // ... let islandImage: UIImage! = UIImage(data: data!)
                }
            }
            
            
            
            if(self.User_profile_pic.image == nil)
            {
                _ = profilePic?.start(completionHandler:  { (connection, result, error) -> Void in
            
                if(error == nil){
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data") as? NSDictionary
                    let urlPic = data?.object(forKey: "url") as! String
                    if let imageData = NSData(contentsOf: URL(string:urlPic)!)
                    {
                        let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
                        let uploadTask = profilePicRef.put(imageData as Data, metadata: nil){
                            metadata,error in
                            
                            if(error == nil)
                            {
                                let downloadUrl = metadata?.downloadURLs
                            }
                            else
                            {
                                print("error in download image")
                            }
                        }
                        
                        self.User_profile_pic.image = UIImage(data: imageData as Data)
                    }
                    
                    
                }
            })
            }
            // User is signed in.
        
        }
            else {
            // No user is signed in.
        }
        
    }
    

    @IBAction func logout(_ sender: AnyObject) {
        
        let user = FIRAuth.auth()?.currentUser
        
        let myConnectionsRef = FIRDatabase.database().reference(withPath: "user_profile/\(user!.uid)/connection/\(self.deviceID!)")
        myConnectionsRef.child("online").setValue(false)
        myConnectionsRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        
        try!FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrent(nil)
        let ViewControl = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let ViewControlNav = UINavigationController(rootViewController:ViewControl)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = ViewControlNav
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 7 && toggle.isOn == false {
//            return 0.0
//        }
//        if indexPath.row == 1 {
//            if toggle.isOn == false || pickerVisible == false {
//                return 0.0
//            }
//            return 117.0
//        }
//        return 44.0
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 6 {
//            pickerVisible = !pickerVisible
//            tableView.reloadData()
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 200.0
//    }
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

    @IBAction func toggleValueChanged(_ sender: AnyObject) {
        self.tableView.reloadData()
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

