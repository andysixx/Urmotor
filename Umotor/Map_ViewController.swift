//
//  Map_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/8/1.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import GoogleMaps

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
