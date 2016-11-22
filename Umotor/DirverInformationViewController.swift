//
//  DirverInformationViewController.swift
//  Umotor
//
//  Created by SIX on 2016/11/16.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
class DirverInformationViewController: UIViewController {
    
    

    let databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"送出", style: UIBarButtonItemStyle.plain, target: self , action: #selector(SendInfo))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title:"離開", style: UIBarButtonItemStyle.plain, target: self , action: #selector(SendInfo))
//        self.navigationItem.hidesBackButton = false
//        self.navigationItem.backBarButtonItem =
//        Driver_licence.translatesAutoresizingMaskIntoConstraints = false
//        Driver_licence.contentMode = .scaleAspectFill
//        Driver_licence.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(handleSelectProfileImageView)))
//        Driver_licence.isUserInteractionEnabled = true
//        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func exit_view(){
    
        dismiss(animated: true, completion: nil)

    }
    func SendInfo(){
        print("123")
        dismiss(animated: true, completion: nil)

//        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
