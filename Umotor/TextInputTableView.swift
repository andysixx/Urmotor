//
//  TextInputTableView.swift
//  Umotor
//
//  Created by SIX on 2016/10/14.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

public class TextInputTableView:UITableViewCell{

    @IBOutlet weak var myTextField: UITextField!
    public func configure(text: String?, placeholder: String) {
        myTextField.text = text
        myTextField.placeholder = placeholder
        
        myTextField.accessibilityValue = text
        myTextField.accessibilityLabel = placeholder
    }

}
