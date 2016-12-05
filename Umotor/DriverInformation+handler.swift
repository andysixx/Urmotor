//
//  DriverInformation+handler.swift
//  Umotor
//
//  Created by SIX on 2016/11/16.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit


extension Diver_Info_TableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func handleSelectProfileImageView()  {
        selectNumber = 0
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func handleSelectProfileImageView_one()  {
        selectNumber = 1
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func handleSelectProfileImageView_two()  {
        selectNumber = 2
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }
        else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            if selectNumber == 0{
                profilePic.image = selectedImage
                 propic += 1
            }
            else if selectNumber == 1{
                 DriverlicencePic.image = selectedImage
                 propic += 1
            }
            else{
                MotorPic.image = selectedImage
                propic += 1
            }
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func exit_view(){
        
        dismiss(animated: true, completion: nil)
    }
    func SendInfo(){
        if nametext.text == "" {showAlertToComplete(alert: "請輸入姓名")}
        else if sextext.text == ""{showAlertToComplete(alert: "請輸入性別")}
        else if phonetext.text == ""{showAlertToComplete(alert: "請輸入手機號碼")}
        else if emailtext.text == ""{showAlertToComplete(alert: "請輸入email")}
        else if MotoNumtext.text == ""{showAlertToComplete(alert: "請輸入車牌")}
        else if areatext.text == ""{showAlertToComplete(alert: "請輸入地區")}
        else if MotoTypetext.text == ""{showAlertToComplete(alert: "請輸入車款")}
        else if CCtext.text == ""{showAlertToComplete(alert: "請輸入CC數(125 c.c.)")}
        else if MotoAgetext.text == ""{showAlertToComplete(alert: "請輸入出廠年份")}
        else if propic == 0{showAlertToComplete(alert: "請檢查照片是否上傳完整")}
        else if propic == 1{showAlertToComplete(alert: "請檢查照片是否上傳完整")}
        else if propic == 2{showAlertToComplete(alert: "請檢查照片是否上傳完整")}
        else{
            showfinishAlert()
            insertDriverInfo()
            navigationItem.leftBarButtonItem = UIBarButtonItem(title:"完成", style: UIBarButtonItemStyle.plain, target: self , action: #selector(exit_view))
            
            navigationItem.rightBarButtonItem = nil
        }
        
    }
    func showfinishAlert(){
        let myAlert = UIAlertController(title: "恭喜你完成了所以有的資訊", message: "你可以開始載客了", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "GO", style: UIAlertActionStyle.default){(ACTION) in
            print("ok")
            

        }
            myAlert.addAction(okAction)
            
            self.present(myAlert, animated: true, completion: nil)
        

    }
    func showAlertToComplete(alert: String!){
        let myAlert = UIAlertController(title: "請完成所有資訊填寫", message: alert, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
            print("ok")
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    func insertDriverInfo(){
        let DriverAllInfor = [
        "driver_mode": true,
            "driver_real_name": nametext.text!,
            "motor_number": MotoNumtext.text!,
            "motor_type": MotoTypetext.text!,
            "motor_cc": CCtext.text!,
            "motor_age": MotoAgetext.text!,
            "id_photo":"",
            "licence_photo":"",
            "driver_email":emailtext.text!,
            "motor_pic":""
        ] as [String : Any]
        ref.child("user_profile").child(userID).child("driver_info").setValue(DriverAllInfor)
        ref.child("user_profile").child(userID).child("phone").setValue(phonetext.text)
        ref.child("user_profile").child(userID).child("gender").setValue(sextext.text!)
        ref.child("user_profile").child(userID).child("school_area").setValue(areatext.text!)
        ref.child("user_profile").child(userID).child("driver_mode").setValue(true)

    
    }
}



