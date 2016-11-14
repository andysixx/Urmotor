//
//  Map_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/1.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseStorage
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
class Map_ViewController: UIViewController{
    var Start_latitude: AnyObject?
    var Start_longitude: AnyObject?
    var End_latitude: AnyObject?
    var End_longitude: AnyObject?
    var regandata: AnyObject?
    var User_ID: AnyObject?
    var Order_ID: AnyObject?
    var loggedInUser = FIRAuth.auth()?.currentUser
    var ref = FIRDatabase.database().reference()
    
    @IBOutlet weak var MapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.User_ID = regandata?.object(forKey: "useruid") as AnyObject
        print(User_ID!)
        print(Order_ID!)
        let Time_point_value = regandata?.object(forKey: "time") as? Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Time_point_value!)
//        self.Custom_Start.text = regandata?.object(forKey: "startpoint") as? String
//        self.Custom_End.text = regandata?.object(forKey: "endpoint") as? String
//        self.TimeLAB.text = dateFormatter.string(from: date as Date)
        let comFromFIR = regandata?.object(forKey: "commit") as? String
        if(comFromFIR != ""){
//            self.Custom_Start.text = comFromFIR
        }
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Start_latitude!.floatValue) , longitude: CLLocationDegrees(Start_longitude!.floatValue), zoom: 17.5)
        MapView.camera =  camera
        let StartMark = GMSMarker()
        
        StartMark.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Start_latitude!.floatValue),longitude: CLLocationDegrees(Start_longitude!.floatValue))
        StartMark.title = "乘客起點位置"
        StartMark.map = MapView
        let Endposition = CLLocationCoordinate2D(latitude: CLLocationDegrees(End_latitude!.floatValue),longitude: CLLocationDegrees(End_longitude!.floatValue))
        let EndMark = GMSMarker(position: Endposition)
        EndMark.title = "乘客目的位置"
        EndMark.map = MapView
        // Do any additional setup after loading the view.
      

    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
         public static func GetDistance_Google(pointA:CLLocationCoordinate2D , pointB:CLLocationCoordinate2D) -> Double
    {
        let EARTH_RADIUS:Double = 6378.137;
        
        let radlng1:Double = pointA.longitude * M_PI / 180.0;
        let radlng2:Double = pointB.longitude * M_PI / 180.0;
        
        let a:Double = radlng1 - radlng2;
        let b:Double = (pointA.latitude - pointB.latitude) * M_PI / 180;
        var s:Double = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radlng1) * cos(radlng2) * pow(sin(b/2), 2)));
        
        s = s * EARTH_RADIUS;
        s = (round(s * 10000) / 10000);
        return s;
    }
}
