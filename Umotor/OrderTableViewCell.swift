//
//  OrderTableViewCell.swift
//  Umotor
//
//  Created by SIX on 2016/11/20.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var EndPoint: UILabel!
    
    @IBOutlet weak var TimeLab: UILabel!
    @IBOutlet weak var StartPoint: UILabel!

    @IBOutlet weak var CustomPic: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
