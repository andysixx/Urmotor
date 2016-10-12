//
//  SelectTableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/10.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit

struct celldata {
    let cell : Int!
    let text : String!
    let image : UIImage!
}
class SelectTableViewController: UITableViewController{
    
    var  arrayOfCellData = [celldata]()
    override func viewDidLoad() {
        arrayOfCellData = [celldata(cell:1,text:"12324",image: #imageLiteral(resourceName: "Image")),
           celldata(cell:1,text:"34534",image: #imageLiteral(resourceName: "Burger")),
        celldata(cell:1,text:"1515",image: #imageLiteral(resourceName: "icon_me")),]
    }
//  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayOfCellData[indexPath.row].cell == 1{
            let cell = Bundle.main.loadNibNamed("TableViewCell1 ", owner: self, options: nil )?.first as! TableViewCell1
            cell.mainimageView.image = arrayOfCellData[indexPath.row].image
            cell.mainLabel.text = arrayOfCellData[indexPath.row].text
            return cell
        
        }else if arrayOfCellData[indexPath.row].cell == 2{
        
            let cell = Bundle.main.loadNibNamed("TableViewCell2 ", owner: self, options: nil )?.first as! TableViewCell2
            cell.mainimageview .image = arrayOfCellData[indexPath.row].image
            cell.mainlb.text = arrayOfCellData[indexPath.row].text
            return cell
        }else{
        
            let cell = Bundle.main.loadNibNamed("TableViewCell1 ", owner: self, options: nil )?.first as! TableViewCell1
            cell.mainimageView.image = arrayOfCellData[indexPath.row].image
            cell.mainLabel.text = arrayOfCellData[indexPath.row].text
            return cell

        }
        
        
    }
      override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].cell == 1{
            
            return 120
        }else if arrayOfCellData[indexPath.row].cell == 2{
            
            return 56
        }else{
            
            return 120
            
        }
    }
}
