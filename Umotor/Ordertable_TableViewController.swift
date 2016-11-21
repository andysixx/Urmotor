//
//  Ordertable_TableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/25.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
//import AlamofireImage

class Ordertable_TableViewController: UITableViewController  {

    @IBOutlet weak var Button: UIBarButtonItem!
    var OrderList = [AnyObject]()
    var loggedInUser: AnyObject?
    var OrderDict : NSDictionary?
    var UID_ID = [AnyObject]()
    var ORD_DI = [AnyObject]()
//    var orde\
//    rs = [Order]()
    let databaseDriverOrderRef = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }// burger side bar menu
        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseDriverOrderRef.child("Call_Moto").observe( .value, with: {(snapshot) in
            self.OrderList = [AnyObject]()
            self.ORD_DI = [AnyObject]()
            self.OrderDict = snapshot.value as? NSDictionary
            if(self.OrderDict != nil){
                for(UserID, orderdetails) in self.OrderDict!{
                    print(UserID)
                    print(orderdetails)
                    if(self.loggedInUser?.uid != UserID as? String)
                    {       self.UID_ID.append(UserID as AnyObject)
                        let waittdetails = (orderdetails as AnyObject).object(forKey: "wait") as? NSDictionary
                        if(waittdetails != nil){
                            for(OrderID ,CustomOrder) in waittdetails!{
                                self.OrderList.append(CustomOrder as AnyObject)
                                //self.ORD_DI.append(OrderID as AnyObject)
                                let _ = self.OrderList.sort { (obj1, obj2) -> Bool in
                                    return (obj1["time"] as! Double) > (obj2["time"] as! Double)
                                }
                            }
                        }
                    }
                    self.tableView?.reloadData()
                }
            }
            self.tableView?.reloadData()

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.OrderList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order_List", for: indexPath) as! Order_TableViewCell
        let Star_point_value = self.OrderList[indexPath.row]["startpoint"] as? String
        let End_point_value = self.OrderList[indexPath.row]["endpoint"] as? String
        let User_picture = self.OrderList[indexPath.row]["picture"] as? String
        let Time_point_value = self.OrderList[indexPath.row]["time"] as? Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Time_point_value!)
        if let url = NSURL(string: User_picture!)
        {
            print("\nstart download: \(url.lastPathComponent!)")
            URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, _, error) -> Void in
                guard let data = data, error == nil else {
                    print("\nerror on download \(error.debugDescription)")
                    return
                }
                DispatchQueue.main.async {
                    cell.Custom_pic.image = UIImage(data: data)
                }
            }).resume()
        }
        cell.Start_point.text = Star_point_value
        cell.Time_point.text = dateFormatter.string(from: date as Date)
        cell.End_point.text = End_point_value
        
        
        // Configure the cell...

        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map_detail"{
            if let indxPath = tableView.indexPathForSelectedRow{
                let navVC = segue.destination as! Order_Map_LocationViewController
                navVC.Start_latitude = self.OrderList[indxPath.row]["startlatitude"] as AnyObject?// 3;
                navVC.Start_longitude = self.OrderList[indxPath.row]["startlongitude"] as AnyObject?
                navVC.End_latitude = self.OrderList[indxPath.row]["endlatitude"] as AnyObject?
                navVC.End_longitude = self.OrderList[indxPath.row]["endlongitude"] as AnyObject?
                navVC.regandata = self.OrderList[indxPath.row] as AnyObject?
               // navVC.Order_ID = self.ORD_DI[indxPath.row] as AnyObject?

            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
