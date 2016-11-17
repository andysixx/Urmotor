//
//  DriverInformation+handler.swift
//  Umotor
//
//  Created by SIX on 2016/11/16.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

extension DirverInformationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func handleSelectProfileImageView()  {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
         //   print((editedImage as AnyObject).size)
            selectedImageFromPicker = editedImage
        }
        else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage{
        //print((originalImage as AnyObject).size)
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            Driver_licence.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        dismiss(animated: true, completion: nil)
    }

}
