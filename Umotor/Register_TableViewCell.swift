//
//  Register_TableViewCell.swift
//  Umotor
//
//  Created by SIX on 2016/11/22.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

class Register_TableViewCell: UITableViewCell {

//    @IBOutlet weak var Label_text: UILabel!
    @IBOutlet weak var Label_text: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class Register_TableViewCell_1: UITableViewCell {
    
//    @IBOutlet weak var email_text: UITextField!
    @IBOutlet weak var Email_image: UIImageView!
//    @IBOutlet weak var Email_image: UIImageView!
    @IBOutlet weak var email_text: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    public func configure(text: String?, placeholder: String) {
        email_text.text = text
        email_text.placeholder = placeholder
        email_text.setValue(UIColor.init(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
        email_text.accessibilityValue = text
        email_text.accessibilityLabel = placeholder
    }
    
}

class Register_TableViewCell_2: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

