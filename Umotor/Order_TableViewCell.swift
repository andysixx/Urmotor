//
//  Order_TableViewCell.swift
//  Umotor
//
//  Created by SIX on 2016/10/25.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

class Order_TableViewCell: UITableViewCell {
    @IBOutlet weak var End_point: UILabel!
    @IBOutlet weak var Custom_pic: UIImageView!
    @IBOutlet weak var Time_point: UILabel!
    @IBOutlet weak var Start_point: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
