//
//  Map_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/1.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import GoogleMaps
import FirebaseStorage
class Map_ViewController: UIViewController,CLLocationManagerDelegate{
//   CLLocationManagerDelegate
    @IBOutlet weak var mapV: GMSMapView!
    @IBOutlet var Button: UIBarButtonItem!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // burger side bar menu
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
            let storage = FIRStorage.storage()
            //refer your particular storage service
            let storageRef = storage.reference(forURL: "gs://umotor-68385.appspot.com")
            
            var profilePic = FBSDKGraphRequest(graphPath: "/{user-id}/picture", parameters: ["height":300,"width":"300","redirect":false],httpMethod:"GET")
            profilePic!.start(completionHandler: {(connection,result,error) -> Void in
                
                if(error == nil)
                {
//                    print("erer")
                    let dictionary = result as? NSDictionary
                    let data = dictionary?.object(forKey: "data")
                    let urlPic = ((data as AnyObject).objectForkey("url"))! as! String
                    
                    if let imageData = NSData(contentsOfURL: NSURL(string:urlPic)!)

                    {
                        let profilePicRef = 
                    }
                }
                
            })

        }
        
     
        
        // Do any additional setup after loading the view.
        
//        GMSServices.provideAPIKey("AIzaSyAJ6EZJ0Acr4z1amx0UB1Vf5vtMpOX-Lzc")
//        let camera = GMSCameraPosition.cameraWithLatitude(24.989424, longitude: 121.544074, zoom: 10)
//        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
//    
//        view = mapView
//        
//        let currentLocation = CLLocationCoordinate2DMake(24.989424, 121.544074)
//        let marker = GMSMarker(position : currentLocation)
//        marker.title = "世新大學"
//        marker.map = mapView
    }
  }
