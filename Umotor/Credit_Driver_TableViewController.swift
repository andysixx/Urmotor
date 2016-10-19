//
//  Credit_Driver_TableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/1.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

private let reuseIdentifier = "Drivercell"

class Credit_Driver_TableViewController: UITableViewController {

    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    let databaseRef = FIRDatabase.database().reference()
    var userDict : NSDictionary? = NSDictionary()
//    var userNameArray = [String]()
//    var userImagesArray = [String]()
    
    var usersArray = [AnyObject]()
    var loggedInUser: AnyObject?
    
    @IBOutlet var Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aivLoading.startAnimating()
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profile").observeSingleEvent(of: .value, with: {
            (snapshot) in
        print(snapshot)
            self.userDict = snapshot.value as? NSDictionary
            self.usersArray = [AnyObject]()
            for(userID,details) in self.userDict!{
                print(userID)
                print(details)
                let img = (details as? NSDictionary)?.object(forKey: "profile_pic_small") as! String
                let name = (details as? NSDictionary)?.object(forKey: "name") as! String
                let firstName = name.components(separatedBy: " ")[0]
                print(firstName)
                let connections = (details as? NSDictionary)?.object(forKey: "connection") as? NSDictionary
                print(connections)
                
                for(deviceID, connection) in connections!{
                    let prpr = (connection as AnyObject).object(forKey: "online")
                    print(prpr as! Bool)
                    let pppp = (details as AnyObject).object(forKey: "online")
                    print(pppp)
                    if((connection as AnyObject).object(forKey: "online") as! Bool)
                    {
                        (details as AnyObject).setValue(true, forKey:"online")
                        
                    }
                    else{
                        if((details as AnyObject).object(forKey: "online") == nil){
                            
                            (details as AnyObject).setValue(false, forKey:"online")
                        }
                    
                    }
                
                }
                if(self.loggedInUser?.uid != userID as? String){
                    (details as AnyObject).setValue(userID, forKey:"uid")
                    self.usersArray.append(details as AnyObject)
                }
                
                print(firstName)
//                self.userNameArray.append(firstName)
//                self.userImagesArray.append(img)
                self.tableView?.reloadData()
                self.aivLoading.stopAnimating()
                self.aivLoading.isHidden = true
            
            }
        
        })
        
        // burger side bar menu
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.performSegue(withIdentifier: "LoginToChat", sender: self.usersArray[indexPath.item])
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override public func numberOfSections(in tableView: UITableView) -> Int{ // Default is 1 if not {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usersArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Driver_TableViewCell
//        let imageUrl = NSURL(string: userImagesArray[indexPath.row])
//        let imageData = NSData(contentsOf : imageUrl! as URL)
//        cell.driverImage.image = UIImage(data: imageData! as Data)
//        cell.DriverName.text = userNameArray[indexPath.row]

        let imageUrl = NSURL(string: self.usersArray[indexPath.row]["profile_pic_small"] as! String)
        let imageData = NSData(contentsOf: imageUrl as! URL)
        cell.driverImage.image = UIImage(data:imageData! as Data)
        
        
//         Configure the cell...
        cell.driverImage.layer.borderWidth = 2.5
        if(self.usersArray[indexPath.row]["online"] as! Bool  ==  true){
        
            cell.driverImage.layer.borderColor = UIColor.green.cgColor
        }
        else{
        
            cell.driverImage.layer.borderColor = UIColor.red.cgColor
        }

        let firstName = (self.usersArray[indexPath.row]["name"] as? String)!.components(separatedBy: " ")[0]
        cell.DriverName.text = firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "Chat", sender: self.usersArray[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                super.prepare(for: segue, sender: sender)
                let navVC = segue.destination as! UINavigationController
                let chatVc = navVC.viewControllers.first as! ChatViewController
                chatVc.senderId = self.loggedInUser?.uid // 3
                chatVc.receiverData = sender as AnyObject?
                chatVc.senderDisplayName = "\((sender as? NSDictionary)?.object(forKey: "name") as! String)" // 4
        
            }

    /*
     Override to support conditional editing of the table view.
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
