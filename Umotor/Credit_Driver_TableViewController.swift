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

class Credit_Driver_TableViewController: UITableViewController{

    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    let databaseRef = FIRDatabase.database().reference()
    var userDict : NSDictionary? = NSDictionary()
    var usersArray = [AnyObject]()
    var friendArray = [AnyObject]()
    var loggedInUser: AnyObject?
    
    @IBOutlet var Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aivLoading.startAnimating()
        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseRef.child("user_profile").child((loggedInUser?.uid)!).observe(.value, with: {
            (snapshot) in
            print(snapshot)
            self.userDict = snapshot.value as? NSDictionary
            print(self.userDict!)
            self.usersArray = [AnyObject]()
            self.friendArray = [AnyObject]()
            for(Cla,details) in self.userDict!{
                print(Cla as! String)
                if(Cla as! String == "friends"){
                  let friendic = details as? NSDictionary
                    print(friendic)
                    if(friendic != nil){
                    for(_, friendsID) in friendic!{
                        print(friendsID)
                        self.friendArray.append(friendsID as AnyObject)
                        }
                    }
                }
            }
        })
        self.databaseRef.child("user_profile").observeSingleEvent(of: .value, with: {
                                        (snapshot1) in
//                                        var idex = 0
                                        let fir = snapshot1.value as? NSDictionary
                                        print(fir!)
            for fridIDD in  self.friendArray{
                for(fid,fdel) in fir!{
                                            
                                            if(fridIDD as! String == fid as! String){
//                                                print(self.friendArray[idex] as! String)
//                                                idex = idex + 1
                                                let connections = (fdel as? NSDictionary)?.object(forKey: "connection") as? NSDictionary
                                                for(_, connection) in connections!{
                                                    if((connection as AnyObject).object(forKey: "online") as! Bool)
                                                    {
                                                        (fdel as AnyObject).setValue(true, forKey:"online")
                                                        
                                                    }
                                                    else{
                                                        if((fdel as AnyObject).object(forKey: "online") == nil){
                                                            
                                                            (fdel as AnyObject).setValue(false, forKey:"online")
                                                        }
                                                        
                                                    }
                                                }
                                                 (fdel as AnyObject).setValue(fid, forKey:"uid")
                                        self.usersArray.append(fdel as AnyObject)
                                                
                                            }
                                        }
            }
            self.tableView?.reloadData()
            self.aivLoading.stopAnimating()
            self.aivLoading.isHidden = true
            self.tableView?.reloadData()
                                    })

        // burger side bar menu
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! Driver_TableViewCell
        tableView.delegate = self
        tableView.dataSource = self
        let imageUrl = NSURL(string: self.usersArray[indexPath.row]["profile_pic_small"] as! String)
        print(self.usersArray[indexPath.row]["profile_pic_small"] as! String)
        let imageData = NSData(contentsOf: imageUrl! as URL)
        cell.driverImage.image = UIImage(data:imageData! as Data)
        cell.driverImage.layer.borderWidth = 2.5
        if(self.usersArray[indexPath.row]["online"] as! Bool  ==  true){
            cell.driverImage.layer.borderColor = UIColor.green.cgColor
        }
        else{
            cell.driverImage.layer.borderColor = UIColor.red.cgColor
        }
        let firstName = (self.usersArray[indexPath.row]["name"] as? String)!.components(separatedBy: " ")[0]
        cell.DriverName.text = firstName
//        self.tableView?.reloadData()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        self.performSegue(withIdentifier: "Chat", sender: self.usersArray[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chat"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let navVC = segue.destination as! ChatViewController
                navVC.senderId = self.loggedInUser?.uid
                navVC.receiverData = self.usersArray[indexPath.row] as AnyObject?
                navVC.senderDisplayName = self.usersArray[indexPath.row]["name"] as! String
                
            }
        }

        
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
