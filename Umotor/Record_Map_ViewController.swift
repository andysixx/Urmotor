//
//  Record_Map_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/11/6.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire
import SwiftyJSON

class Record_Map_ViewController: UIViewController {

    @IBOutlet weak var GMapView: GMSMapView!
    @IBOutlet weak var Start_point_lab: UILabel!
    @IBOutlet weak var TimeLab: UILabel!
    @IBOutlet weak var End_point_lab: UILabel!
    @IBOutlet weak var mode_lab: UILabel!
    @IBOutlet weak var commit: UILabel!
    @IBOutlet weak var Chat_to_driver: UIButton!
    var Start_latitude: AnyObject?
    var Start_longitude: AnyObject?
    var End_latitude: AnyObject?
    var End_longitude: AnyObject?
    var regandata: AnyObject?
    var User_ID: AnyObject?
    var Order_ID: AnyObject?
    var userDict : NSDictionary?
    var tableMode: String?
    var loggedInUser = FIRAuth.auth()?.currentUser
    var ref = FIRDatabase.database().reference()
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.User_ID = regandata?.object(forKey: "useruid") as AnyObject
        self.Order_ID = regandata?.object(forKey: "orderid") as AnyObject
        let Time_point_value = regandata?.object(forKey: "time") as? Double
        let driveridsend = regandata?.object(forKey: "thedriver") as AnyObject
        regandata?.setValue(driveridsend, forKey: "uid")
        print(regandata!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Time_point_value!)
        self.Start_point_lab.text = regandata?.object(forKey: "startpoint") as? String
        self.End_point_lab.text = regandata?.object(forKey: "endpoint") as? String
        let stlat :String = String(format:"%f", Start_latitude!.doubleValue)
        let stlng :String = String(format:"%f", Start_longitude!.doubleValue)
        print(Start_latitude!.doubleValue)
        print(Start_longitude!.floatValue)
        print(End_latitude!.floatValue)
        print(End_latitude!.floatValue)
        let orginal = stlat + "," + stlng
        let edlat :String = String(format:"%f", End_latitude!.doubleValue)
        let edlng :String = String(format:"%f", End_longitude!.doubleValue)
        let destinal = edlat + "," + edlng
        
        directionAPITest(origin: orginal , destination: destinal)
        print((self.User_ID)! as! String)
        print(self.tableMode!)
        print((self.Order_ID)! as! String)
    self.ref.child("Call_Moto").child((self.User_ID)! as! String).child(self.tableMode!).child((self.Order_ID)! as! String).observe(.value, with: {(snapshot) in
            self.userDict = snapshot.value as? NSDictionary
        for(Type,details) in self.userDict!{
            print(Type)
            print(details)
            if(Type as! String == "mode")
            {
                self.mode_lab.text = details as? String
            }
            else if(Type as! String == "thedriver"){
                if(details as! String != "無"){
                    self.Chat_to_driver.isEnabled = true
                }
                else{
                    self.Chat_to_driver.isEnabled = false
                }
            }
        }
        
        })
        self.TimeLab.text = dateFormatter.string(from: date as Date)
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Start_latitude!.doubleValue) , longitude: CLLocationDegrees(Start_longitude!.doubleValue), zoom: 17.5)
        GMapView.camera =  camera
        let StartMark = GMSMarker()
        
        StartMark.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Start_latitude!.doubleValue),longitude: CLLocationDegrees(Start_longitude!.doubleValue))
        StartMark.title = "乘客起點位置"
        StartMark.map = GMapView
        let Endposition = CLLocationCoordinate2D(latitude: CLLocationDegrees(End_latitude!.doubleValue),longitude: CLLocationDegrees(End_longitude!.doubleValue))
        let EndMark = GMSMarker(position: Endposition)
        EndMark.title = "乘客目的位置"
        EndMark.map = GMapView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func directionAPITest(origin: String!, destination: String!) {
        var directionsURLString = baseURLDirections + "origin=" + origin + "&destination=" + destination
        
        directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        Alamofire.request(directionsURLString).responseJSON
            { response in
                print(response.request!)  // original URL request
                print(response.response!) // HTTP URL response
                print(response.data!)     // server data
                print(response.result)   // result of response serialization
                if let dictionary: NSDictionary = response.result.value  as? NSDictionary {
                    print("JSON: \(dictionary)")
                    let parsedData = JSON(response.result.value!)
                    let status = dictionary["status"] as! String
                    if status == "OK" {
                        let routes = dictionary["routes"] as! [NSDictionary]
                        print(routes)
                        let path = GMSPath.init(fromEncodedPath: (parsedData["routes"][0]["overview_polyline"]["points"].string)!)
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 5
                        singleLine.geodesic = true
                        singleLine.map = self.GMapView
                    }
                }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Chat_to_driver"{
//            if let indexPath = tableView.indexPathForSelectedRow{
                let navVC = segue.destination as! ChatViewController
                navVC.senderId = self.loggedInUser?.uid
                navVC.receiverData = regandata
                navVC.senderDisplayName = "聯絡司機"
                
//            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
