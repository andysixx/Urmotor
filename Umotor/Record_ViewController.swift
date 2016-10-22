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
    var UserAllrecordArray = [AnyObject]()
    var UserWaitrecordArray = [AnyObject]()
    var UserIngrecordArray = [AnyObject]()
    var UserFinishrecordArray = [AnyObject]()
    var UserCancelrecordArray = [AnyObject]()
    var loggedInUser: AnyObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseCallCarRef.child("user_profile").observeSingleEvent(of: .value, with: {(snapshot) in
                self.userDict = snapshot.value as? NSDictionary
            for(userID,details) in self.userDict!{
                if(self.loggedInUser?.uid != userID as? String){
                    (details as AnyObject).setValue(userID, forKey:"uid")

                }
            }
            
            })       // burger side bar menu
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
            returnValue = 14
            break
        case 1:
                        returnValue = 2
            break
        case 2:
                        returnValue = 6
            break
        case 3:
                        returnValue = 4
            break
        case 4:
                        returnValue = 1
            break
        default:
            break
        }
        return returnValue
    }
    
 
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath)
        return cell
    }

    @IBAction func Change_type(_ sender: AnyObject) {
        MyTableView.reloadData()
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
