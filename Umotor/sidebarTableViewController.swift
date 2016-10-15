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
class sidebarTableViewController: UITableViewController {

    
    
    @IBOutlet weak var User_profile_pic: UIImageView!
//    @IBOutlet weak var User_profile_pic: UIImageView!
    @IBOutlet weak var User_name: UILabel!
    override func viewDidLoad() {
       
        super.viewDidLoad()
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
            let data = NSData(contentsOf:photoUrl!)
            self.User_profile_pic.image = UIImage(data:data as! Data)
            
//            if(self.User_profile_pic.image == nil)
//            {
//            
//            var profilePic = FBSDKGraphRequest(graphPath: "/{user-id}/picture", parameters: ["height":300,"width":300,"redirect":false],httpMethod:"GET")
//            profilePic?.start(completionHandler: {(connection,result,error) -> Void in
//            
//                if(error == nil)
//                {
//                    let dictionary = result as? NSDictionary
//                    let data = dictionary?.object(forKey: "data") as! NSDictionary
//                    
//                    let urlPic = data.object(forKey: "url") as! String
//                    
//                    if let imageData = NSData(contentsOf: NSURL(string:urlPic) as! URL)
//                        
//                    {
//                        let profilePicRef = storageRef.child(user.uid+"/profile_pic.jpg")
//                        let uploadTask = profilePicRef.put(imageData as Data, metadata:nil){
//                         metadata,error in
//                            if(error == nil)
//                            {
//                                let downloadUrl = metadata?.downloadURL
//                            }
//                            else{
//                                print("error in downloading image")
//                            }
//                        }
//                        self.User_profile_pic.image = UIImage(data:imageData as Data)
//                    }
//                }
//            
//            })
//            }//end if
//            
//            // User is signed in.
        } else {
            // No user is signed in.
        }
        }
    

    @IBAction func logout(_ sender: AnyObject) {
        try!FIRAuth.auth()!.signOut()
        FBSDKAccessToken.setCurrent(nil)
        let ViewControl = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerFirst") as! ViewControllerFirst
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

