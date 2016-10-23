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
class Map_ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate{
//   CLLocationManagerDelegate
    @IBOutlet weak var MapV: MKMapView!
    @IBOutlet weak var checkdouble: UIButton!
    @IBOutlet var Button: UIBarButtonItem!
    @IBOutlet weak var Adress: UITextField!
    @IBOutlet weak var end_adress: UITextField!
    @IBOutlet weak var set_location: UIButton!
    var geoCoder: CLGeocoder!
    var locationManager = CLLocationManager()
    var previousAddress: String!
    var didFindMyLocation = false
    @IBOutlet weak var commition: UITextField!
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
        @IBAction func Call_car_now(_ sender: AnyObject) {
        self.set_location.isHidden = true
        self.checkdouble.isHidden = false
            self.end_adress.isHidden = false
            self.commition.isHidden = false
            
        
    }
    @IBAction func Check_call_car(_ sender: AnyObject) {
        
        
        let MapMotorPoint = [ // 2
            "startpoint": (Adress.text)! as String,
            "endpoint":(end_adress.text)! as String,
            "commit":(commition.text)! as String,
            "callcaruser": user?.uid,
            "user": user?.photoURL
        ] as [String : Any]
        ref.child("Call_Moto").child((user?.uid)!).child("all").childByAutoId().setValue(MapMotorPoint)
ref.child("Call_Moto").child((user?.uid)!).child("wait").childByAutoId().setValue(Adress.text)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        MapV.showsUserLocation = true
        //Setup our Map View
        geoCoder = CLGeocoder()
        self.MapV.delegate = self
        // burger side bar menu
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = #selector(SWRevealViewController.revealToggle(_:))
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
        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate,30,30)
        self.MapV.setRegion(reg, animated: true)
        locationManager.stopUpdatingLocation()
//        geoCode(location: location)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCode(location: location)
    }//end move animate
    func geoCode(location : CLLocation!){
        geoCoder.cancelGeocode()
        if(self.set_location.isHidden == false){
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
        else{
            geoCoder.reverseGeocodeLocation(location, completionHandler: {(data,error) -> Void in
                guard let placeMarks = data as[CLPlacemark]! else{
                    
                    return
                }
                let loc : CLPlacemark = placeMarks[0]
                let addressDict : [NSString : NSObject] = loc.addressDictionary as! [NSString : NSObject]
                let addrList = addressDict["FormattedAddressLines"] as! [String]
                let address = addrList.joined(separator: ", ")
                print(address)
                self.end_adress.text = address
                self.previousAddress = address
        
        })
        }
    
    
    }
   
}
