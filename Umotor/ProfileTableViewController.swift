//
//  ProfileTableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/14.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class ProfileTableViewController: UITableViewController {

    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    var about = ["姓名","年齡","電話","性別","學校地區","email"]
    @IBAction func didTapUpdate(_ sender: AnyObject) {
        
        var index = 0
       
        while index<about.count{
            let indePath = IndexPath(row: index, section: 0)
            let cell: TextInputTableView? = self.tableView.cellForRow(at: indePath) as! TextInputTableView
            
            if cell?.myTextField.text != ""{
            
                let item:String = (cell?.myTextField.text!)!
                
                switch self.about[index] {
                    case "姓名":
                    self.ref.child("user_profile").child("\(user!.uid)/name").setValue(item)
                    break
                    case "年齡":
                        self.ref.child("user_profile").child("\(user!.uid)/age").setValue(item)
                    break
                    case "電話":
                        self.ref.child("user_profile").child("\(user!.uid)/phone").setValue(item)
                    break
                    case "性別":
                        self.ref.child("user_profile").child("\(user!.uid)/gender").setValue(item)
                    break
                    case "學校地區":
                        self.ref.child("user_profile").child("\(user!.uid)/school_area").setValue(item)
                    break
                    case "email":
                        self.ref.child("user_profile").child("\(user!.uid)/email").setValue(item)
                    break
                
                    default:
                    print("dont update")
                }//end switch
            }//end if
            index+=1    
        }
    }
    
    
    
    @IBOutlet weak var Button: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView(frame:CGRect.zero)
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
            
        }
       
       var refHandle = self.ref.child("user_profile").observe(FIRDataEventType.value, with: { (snapshot) in
            let usersDict = snapshot.value as! NSDictionary
            let userDetails = usersDict.object(forKey: self.user!.uid) as! NSDictionary
            print(userDetails)
            var index = 0
    
    
        while index<self.about.count{
            let indePath = IndexPath(row: index, section: 0)
            let cell: TextInputTableView? = self.tableView.cellForRow(at: indePath) as! TextInputTableView?
            let field: String = (cell?.myTextField.placeholder?.lowercased())!
            print(field)
        
                switch field {
                case "姓名":
                    cell?.configure(text: userDetails.object(forKey: "name") as? String, placeholder:"姓名")
                    break
                case "年齡":
                    cell?.configure(text: userDetails.object(forKey: "age") as? String, placeholder:"年齡")
                    break
                case "電話":
                   cell?.configure(text: userDetails.object(forKey: "phone") as? String, placeholder:"電話")
                    break
                case "性別":
                    cell?.configure(text: userDetails.object(forKey: "gender") as? String, placeholder:"性別")
                    break
                case "學校地區":
                    cell?.configure(text: userDetails.object(forKey: "school_area") as? String, placeholder:"學校地區")
                    break
                case "email":
                    cell?.configure(text: userDetails.object(forKey: "email") as? String, placeholder:"email")
                    break
//
                default:
                    print("dont update")
                }//end switch
            index+=1
            }//end if
        
        

//            // ...
        })
//
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }

//    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TextInputTableView = tableView.dequeueReusableCell(withIdentifier: "TextInput", for: indexPath)
            as! TextInputTableView
        cell.configure(text: "", placeholder: "\(about[indexPath.row])")

        // Configure the cell...

        return cell
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
