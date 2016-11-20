//
//  Diver_Info_TableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/11/19.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class Diver_Info_TableViewController: UITableViewController {

    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var sextext: UITextField!
    @IBOutlet weak var phonetext: UITextField!
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var MotoNumtext: UITextField!
    @IBOutlet weak var areatext: UITextField!
    @IBOutlet weak var MotoTypetext: UITextField!
    @IBOutlet weak var CCtext: UITextField!
    @IBOutlet weak var MotoAgetext: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var DriverlicencePic: UIImageView!
    @IBOutlet weak var MotorPic: UIImageView!
    var propic = 0
    let ref = FIRDatabase.database().reference()
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
        self.userID = user?.uid
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"送出", style: UIBarButtonItemStyle.plain, target: self , action: #selector(SendInfo))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"離開", style: UIBarButtonItemStyle.plain, target: self , action: #selector(exit_view))
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        profilePic.contentMode = .scaleAspectFill
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleSelectProfileImageView)))
        profilePic.isUserInteractionEnabled = true
        
        DriverlicencePic.translatesAutoresizingMaskIntoConstraints = false
        DriverlicencePic.contentMode = .scaleAspectFill
        DriverlicencePic.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleSelectProfileImageView)))
        DriverlicencePic.isUserInteractionEnabled = true
        
        MotorPic.translatesAutoresizingMaskIntoConstraints = false
        MotorPic.contentMode = .scaleAspectFill
        MotorPic.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleSelectProfileImageView)))
        MotorPic.isUserInteractionEnabled = true
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var rowCount = 0
        if section == 0 {
            rowCount = 9
        }
        if section == 1 {
            rowCount = 3
        }
        return rowCount
    }
    
   
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
