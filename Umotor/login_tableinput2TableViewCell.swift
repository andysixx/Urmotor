//
//  login_tableinput2TableViewCell.swift
//  Umotor
//
//  Created by SIX on 2016/11/18.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

class login_tableinput2TableViewCell: UITableViewCell {

    @IBOutlet weak var textfiledCum: UITextField!
    @IBOutlet weak var icon_plan: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    public func configure(text: String?, placeholder: String) {
        textfiledCum.text = text
        textfiledCum.placeholder = placeholder
        textfiledCum.setValue(UIColor.init(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 1.0), forKeyPath: "_placeholderLabel.textColor")
        textfiledCum.accessibilityValue = text
        textfiledCum.accessibilityLabel = placeholder
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
