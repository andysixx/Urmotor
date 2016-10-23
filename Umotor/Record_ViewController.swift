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

class Record_ViewController: UIViewController,UITableViewDataSource,URLSessionDataDelegate {

    @IBOutlet weak var RecordOfCallCarSeg: UISegmentedControl!
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet var Button: UIBarButtonItem!
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
    var loggedInUser: AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseCallCarRef.child("Call_Moto").child((self.loggedInUser?.uid)!).observeSingleEvent(of: .value, with: {(snapshot) in

                print(snapshot)
                self.userDict = snapshot.value as? NSDictionary
            
//            let Call_car_type = self.userDict?.object(forKey: "all")
            for(Type,details) in self.userDict!{
                if(Type as! String == "all"){
                    let alldetails = self.userDict?.object(forKey: "all") as? NSDictionary
                    print(alldetails!)
                    for(_, detail_all) in alldetails!{
                        self.UserAllrecordArray.append(detail_all as AnyObject)
                    }
                
                }
                if(Type as! String == "wait"){
                    let alldetails = self.userDict?.object(forKey: "wait") as? NSDictionary
                    print(alldetails!)
                    for(_, detail_wait) in alldetails!{
                        self.UserWaitrecordArray.append(detail_wait as AnyObject)
                    }
                    
                }

                print(Type)
                print(details)
            }
            
//                    self.UserWaitrecordArray.append(details as AnyObject)
//                    print(details)
//                    let waitcarorder = (details as? NSDictionary)?.object(forKey: "wait")
//                    let allcarorder = (details as? NSDictionary)?.object(forKey: "all")

            
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
        default:
            break
        }
        return returnValue
    }
    
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! RecordTableViewCell
        switch (RecordOfCallCarSeg.selectedSegmentIndex) {
        case 0:
            let all = (self.UserAllrecordArray[indexPath.row] as? String)
            print(all)
            cell.LocationFirst.text = all
            break
        case 1:
            let all = (self.UserWaitrecordArray[indexPath.row] as? String)
            cell.LocationFirst.text = all
//            returnValue = UserWaitrecordArray.count
            break
        case 2:
//            returnValue = 6
            break
        case 3:
//            returnValue = 4
            break
        default:
            break
        }
        return cell
    }

    @IBAction func Change_type(_ sender: AnyObject) {
        self.MyTableView.reloadData()
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
