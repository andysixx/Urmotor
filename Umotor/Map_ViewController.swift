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
import  CoreLocation
class Map_ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{
//   CLLocationManagerDelegate
    @IBOutlet weak var MapV: MKMapView!
    @IBOutlet var Button: UIBarButtonItem!
    @IBOutlet weak var Adress: UITextField!
    var geoCoder: CLGeocoder!
    var locationManager = CLLocationManager()
    var previousAddress: String!
    var didFindMyLocation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        geoCoder = CLGeocoder()
        self.MapV.delegate = self
        // burger side bar menu
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = "revealToggle:"
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
            
        }
        // Do any additional setup after loading the view.
    
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation =  locations.first!
        self.MapV.centerCoordinate = location.coordinate
        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate,1500,1500)
        self.MapV.setRegion(reg, animated: true)
        geoCode(location: location)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCode(location: location)
    }
    func geoCode(location : CLLocation!){
        geoCoder.cancelGeocode()
        geoCoder.reverseGeocodeLocation(location, completionHandler: {(data,error) -> Void in
            guard let placeMarks = data as[CLPlacemark]! else{
            
                return
            }
            let loc : CLPlacemark = placeMarks[0]
            let addressDict : [NSString : NSObject] = loc.addressDictionary as! [NSString : NSObject]
            let addrList = addressDict["FormattedAddressLines"] as! [String]
            let address = addrList.joined(separator: ", ")
            print(address)
            self.Adress.text = address
            self.previousAddress = address
            
        })
    
    
    
    }
}
