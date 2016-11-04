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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
      

    
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
