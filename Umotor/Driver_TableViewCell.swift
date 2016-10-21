//
//  Driver_TableViewCell.swift
//  Umotor
//
//  Created by SIX on 2016/10/17.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

class Driver_TableViewCell: UITableViewCell {

    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var DriverName: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeItRound()
        
    }
    func makeItRound(){
//    
//        self.driverImage.layer.masksToBounds = true
        
        self.driverImage.layoutIfNeeded()
        self.driverImage.layer.cornerRadius = self.driverImage.frame.size.width/2.0
        self.driverImage.clipsToBounds = true
    }

}
