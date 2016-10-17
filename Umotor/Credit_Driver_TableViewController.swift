//
//  Credit_Driver_TableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/1.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Credit_Driver_TableViewController: UITableViewController {

    let databaseRef = FIRDatabase.database().reference()
    var userDict = NSDictionary()
    var userNameArray = [String]()
    var userImagesArray = [String]()
    @IBOutlet var Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.databaseRef.child("user_profile").observeSingleEvent(of: .value, with: {snapshot in
        print(snapshot)
            self.userDict = (snapshot.value as? NSDictionary)!
            for(userID,details) in self.userDict {
                print(userID)
                print(details)
                let img = (details as? NSDictionary)?.object(forKey: "profile_pic_small") as! String
                let name = (details as? NSDictionary)?.object(forKey: "name") as! String
                let firstName = name.components(separatedBy: " ")[0]
                print(firstName)
                self.userNameArray.append(firstName)
                self.userImagesArray.append(img)
                self.tableView?.reloadData()
            
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
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return self.userNameArray.count
    }

//    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Drivercell", for: indexPath) as! Driver_TableViewCell
        let imageUrl = NSURL(string: userImagesArray[indexPath.row])
        let imageData = NSData(contentsOf : imageUrl! as URL)
        cell.driverImage.image = UIImage(data: imageData! as Data)
        cell.DriverName.text = userNameArray[indexPath.row]

        
//         Configure the cell...

        return cell
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
