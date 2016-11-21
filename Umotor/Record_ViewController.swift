//
//  Record_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/1.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Record_ViewController: UIViewController, URLSessionDataDelegate, UITableViewDataSource {

 
    @IBOutlet weak var RecordOfCallCarSeg: UISegmentedControl!
    @IBOutlet weak var Button: UIBarButtonItem!
    @IBOutlet weak var MyTableView: UITableView!
    var returnValueAll = 0
    var returnValueWait = 0
    var returnValueIng = 0
    var returnValueFinish = 0
    var returnValueCancel = 0
    let databaseCallCarRef = FIRDatabase.database().reference()
    var userDict : NSDictionary?
    var UserDetails : NSDictionary?
    var UserAllrecordArray = [AnyObject]()
    var UserWaitrecordArray = [AnyObject]()
    var UserIngrecordArray = [AnyObject]()
    var UserFinishrecordArray = [AnyObject]()
    var UserCancelrecordArray = [AnyObject]()
    var loggedInUser: AnyObject?
    
//    @IBOutlet weak var table_view: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseCallCarRef.child("Call_Moto").child((self.loggedInUser?.uid)!).observe(.value, with: {(snapshot) in
                print(snapshot)
                self.userDict = snapshot.value as? NSDictionary
            self.UserAllrecordArray = [AnyObject]()
            self.UserWaitrecordArray = [AnyObject]()
            self.UserIngrecordArray = [AnyObject]()
            self.UserFinishrecordArray = [AnyObject]()
            self.UserCancelrecordArray = [AnyObject]()
            if(self.userDict != nil){
            for(Type,details) in self.userDict!{
                if(Type as! String == "all"){
                    let alldetails = self.userDict?.object(forKey: "all") as? NSDictionary
                    print(alldetails!)
                    for(OrderID, detail_all) in alldetails!{
                        self.UserAllrecordArray.append(detail_all as AnyObject)
                        let _ = self.UserAllrecordArray.sort { (obj1, obj2) -> Bool in
                            return (obj1["time"] as! Double) > (obj2["time"] as! Double)}
                       // self.OrderAllID.append(OrderID as AnyObject)
                    }
                
                }
                if(Type as! String == "wait"){
                    let alldetails = self.userDict?.object(forKey: "wait") as? NSDictionary
                    print(alldetails!)
                    for(OrderID, detail_wait) in alldetails!{
                        self.UserWaitrecordArray.append(detail_wait as AnyObject)
                        let _ = self.UserWaitrecordArray.sort { (obj1, obj2) -> Bool in
                            return (obj1["time"] as! Double) > (obj2["time"] as! Double)}
                        //self.OrderWaitID.append(OrderID as AnyObject)
                    }
                    
                }
                if(Type as! String == "ing"){
                    let alldetails = self.userDict?.object(forKey: "ing") as? NSDictionary
                    print(alldetails!)
                    for(OrderID, detail_wait) in alldetails!{
                        print(detail_wait)
                        print(Type)
                        self.UserIngrecordArray.append(detail_wait as AnyObject)
                        let _ = self.UserIngrecordArray.sort { (obj1, obj2) -> Bool in
                            return (obj1["time"] as! Double) > (obj2["time"] as! Double)}
                        //self.OrderIngID.append(OrderID as AnyObject)
                    }
                    
                }
                if(Type as! String == "finished"){
                    let alldetails = self.userDict?.object(forKey: "finished") as? NSDictionary
                    print(alldetails!)
                    for(OrderID, detail_wait) in alldetails!{
                        self.UserFinishrecordArray.append(detail_wait as AnyObject)
                        let _ = self.UserFinishrecordArray.sort { (obj1, obj2) -> Bool in
                            return (obj1["time"] as! Double) > (obj2["time"] as! Double)}
                       // self.OrderFinishID.append(OrderID as AnyObject)
                    }
                    
                }
                if(Type as! String == "cancel"){
                    let alldetails = self.userDict?.object(forKey: "cancel") as? NSDictionary
                    print(alldetails!)
                    for(OrderID, detail_wait) in alldetails!{
                        self.UserCancelrecordArray.append(detail_wait as AnyObject)
                        let _ = self.UserCancelrecordArray.sort { (obj1, obj2) -> Bool in
                            return (obj1["time"] as! Double) > (obj2["time"] as! Double)}
                       // self.OrderCancelID.append(OrderID as AnyObject)
                    }
                    
                }

                print(Type)
                print(details)
            }
            }
            self.MyTableView?.reloadData()
        })
        // burger side bar menu
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var returnValue = 0

        switch (RecordOfCallCarSeg.selectedSegmentIndex) {
        case 0:
            returnValue = UserAllrecordArray.count
            break
        case 1:
                        returnValue = UserWaitrecordArray.count
            break
        case 2:
                        returnValue = UserIngrecordArray.count
            break
        case 3:
                        returnValue = UserFinishrecordArray.count
            break
        case 4:
            returnValue = UserCancelrecordArray.count
            break
        default:
            break
        }
        return returnValue
    }
    
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! RecordTableViewCell
        switch (RecordOfCallCarSeg.selectedSegmentIndex) {
        case 0:
            let allstart_point = (self.UserAllrecordArray[indexPath.row]["startpoint"] as? String)
            let allend_point = (self.UserAllrecordArray[indexPath.row]["endpoint"] as? String)
            let all_mode = (self.UserAllrecordArray[indexPath.row]["mode"] as? String)
            let all_price = (self.UserAllrecordArray[indexPath.row]["distance"] as? String)
            let timInterval = (self.UserAllrecordArray[indexPath.row]["time"] as? Double)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = NSDate(timeIntervalSince1970: timInterval!)
            cell.time_lab.text = dateFormatter.string(from: date as Date)
            cell.LocationFirst.text = allstart_point
            cell.Locationend.text = allend_point
            cell.State_mode.text = all_mode
            cell.priceLab.text = all_price
            
            
            break
            
        case 1:
            let waitstart_point = (self.UserWaitrecordArray[indexPath.row]["startpoint"] as? String)
            let waitend_point = (self.UserWaitrecordArray[indexPath.row]["endpoint"] as? String)
            let wait_mode = (self.UserWaitrecordArray[indexPath.row]["mode"] as? String)
            let wait_price = (self.UserWaitrecordArray[indexPath.row]["distance"] as? String)
            let timInterval = (self.UserWaitrecordArray[indexPath.row]["time"] as? Double)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = NSDate(timeIntervalSince1970: timInterval!)
            cell.time_lab.text = dateFormatter.string(from: date as Date)
            cell.LocationFirst.text = waitstart_point
            cell.Locationend.text = waitend_point
            cell.State_mode.text = wait_mode
            cell.priceLab.text = wait_price
            break
        case 2:
            let waitend_point = (self.UserIngrecordArray[indexPath.row]["endpoint"] as? String)
            let wait_mode = (self.UserIngrecordArray[indexPath.row]["mode"] as? String)
            let timInterval = (self.UserIngrecordArray[indexPath.row]["time"] as? Double)
            let wait_price = (self.UserIngrecordArray[indexPath.row]["distance"] as? String)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = NSDate(timeIntervalSince1970: timInterval!)
            cell.time_lab.text = dateFormatter.string(from: date as Date)
            cell.LocationFirst.text = waitend_point
            cell.Locationend.text = waitend_point
            cell.State_mode.text = wait_mode
            cell.priceLab.text = wait_price
            break
        case 3:
            let waitend_point = (self.UserFinishrecordArray[indexPath.row]["endpoint"] as? String)
            let wait_mode = (self.UserFinishrecordArray[indexPath.row]["mode"] as? String)
            let timInterval = (self.UserFinishrecordArray[indexPath.row]["time"] as? Double)
            let wait_price = (self.UserFinishrecordArray[indexPath.row]["distance"] as? String)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = NSDate(timeIntervalSince1970: timInterval!)
            cell.time_lab.text = dateFormatter.string(from: date as Date)
            cell.LocationFirst.text = waitend_point
            cell.Locationend.text = waitend_point
            cell.State_mode.text = wait_mode
            cell.priceLab.text = wait_price
            break
        case 4:
            let waitend_point = (self.UserCancelrecordArray[indexPath.row]["endpoint"] as? String)
            let wait_mode = (self.UserCancelrecordArray[indexPath.row]["mode"] as? String)
            let timInterval = (self.UserCancelrecordArray[indexPath.row]["time"] as? Double)
            let wait_price = (self.UserCancelrecordArray[indexPath.row]["distance"] as? String)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = NSDate(timeIntervalSince1970: timInterval!)
            cell.time_lab.text = dateFormatter.string(from: date as Date)
            cell.LocationFirst.text = waitend_point
            cell.Locationend.text = waitend_point
            cell.State_mode.text = wait_mode
            cell.priceLab.text = wait_price
            break
            
        default:
            break
        }
        return cell
    }

    @IBAction func Change_type(_ sender: Any) {
        self.MyTableView.reloadData()
    }
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapmapmap"{
            if let indxPath = self.MyTableView.indexPathForSelectedRow{
                let navVC = segue.destination as! Record_Map_ViewController
        
                switch (RecordOfCallCarSeg.selectedSegmentIndex) {
                case 0:
                    navVC.Start_latitude = self.UserAllrecordArray[indxPath.row]["startlatitude"] as AnyObject?// 3;
                    navVC.Start_longitude = self.UserAllrecordArray[indxPath.row]["startlongitude"] as AnyObject?
                    navVC.End_latitude = self.UserAllrecordArray[indxPath.row]["endlatitude"] as AnyObject?
                    navVC.End_longitude = self.UserAllrecordArray[indxPath.row]["endlongitude"] as AnyObject?
                    navVC.regandata = self.UserAllrecordArray[indxPath.row] as AnyObject?
                   // navVC.Order_ID = self.OrderAllID[indxPath.row] as AnyObject?
                    navVC.tableMode = "all"
                    
                
                    break
                case 1:
                    navVC.Start_latitude = self.UserWaitrecordArray[indxPath.row]["startlatitude"] as AnyObject?// 3;
                    navVC.Start_longitude = self.UserWaitrecordArray[indxPath.row]["startlongitude"] as AnyObject?
                    navVC.End_latitude = self.UserWaitrecordArray[indxPath.row]["endlatitude"] as AnyObject?
                    navVC.End_longitude = self.UserWaitrecordArray[indxPath.row]["endlongitude"] as AnyObject?
                    navVC.regandata = self.UserWaitrecordArray[indxPath.row] as AnyObject?
                   // navVC.Order_ID = self.OrderWaitID[indxPath.row] as AnyObject?
                    navVC.tableMode = "wait"
                        
                    break
                case 2:
                    navVC.Start_latitude = self.UserIngrecordArray[indxPath.row]["startlatitude"] as AnyObject?// 3;
                    navVC.Start_longitude = self.UserIngrecordArray[indxPath.row]["startlongitude"] as AnyObject?
                    navVC.End_latitude = self.UserIngrecordArray[indxPath.row]["endlatitude"] as AnyObject?
                    navVC.End_longitude = self.UserIngrecordArray[indxPath.row]["endlongitude"] as AnyObject?
                    navVC.regandata = self.UserIngrecordArray[indxPath.row] as AnyObject?
                   // navVC.Order_ID = self.OrderIngID[indxPath.row] as AnyObject?
                    navVC.tableMode = "ing"
                    break
                case 3:
                    navVC.Start_latitude = self.UserFinishrecordArray[indxPath.row]["startlatitude"] as AnyObject?// 3;
                navVC.Start_longitude = self.UserFinishrecordArray[indxPath.row]["startlongitude"] as AnyObject?
                navVC.End_latitude = self.UserFinishrecordArray[indxPath.row]["endlatitude"] as AnyObject?
                navVC.End_longitude = self.UserFinishrecordArray[indxPath.row]["endlongitude"] as AnyObject?
                navVC.regandata = self.UserFinishrecordArray[indxPath.row] as AnyObject?
                  //  navVC.Order_ID = self.OrderFinishID[indxPath.row] as AnyObject?
                    navVC.tableMode = "finished"
                    break
                case 4:
                    navVC.Start_latitude = self.UserCancelrecordArray[indxPath.row]["startlatitude"] as AnyObject?// 3;
                    navVC.Start_longitude = self.UserCancelrecordArray[indxPath.row]["startlongitude"] as AnyObject?
                    navVC.End_latitude = self.UserCancelrecordArray[indxPath.row]["endlatitude"] as AnyObject?
                    navVC.End_longitude = self.UserCancelrecordArray[indxPath.row]["endlongitude"] as AnyObject?
                    navVC.regandata = self.UserCancelrecordArray[indxPath.row] as AnyObject?
                 //   navVC.Order_ID = self.OrderCancelID[indxPath.row] as AnyObject?
                    navVC.tableMode = "cancel"
                    break
                default:
                    break
                }
                
                
            
        

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
        }
    }
    

}
