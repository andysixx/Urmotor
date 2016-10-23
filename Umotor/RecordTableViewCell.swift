//
//  RecordTableViewCell.swift
//  Umotor
//
//  Created by SIX on 2016/10/23.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var UserPic: UIImageView!
    @IBOutlet weak var LocationFirst: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
