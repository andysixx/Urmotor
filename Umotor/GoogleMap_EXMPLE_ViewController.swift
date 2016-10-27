//
//  GoogleMap_EXMPLE_ViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/26.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import GoogleMapsCore
import GoogleMaps
import GoogleMapsBase
import CoreLocation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class GoogleMap_EXMPLE_ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    @IBOutlet weak var Start_position: UITextField!
    @IBOutlet weak var GMapView: GMSMapView!
    @IBOutlet weak var ButtonBar: UIBarButtonItem!
    @IBOutlet weak var End_position: UITextField!
    
    @IBOutlet weak var commit: UITextField!
    @IBOutlet weak var set_location: UIButton!
    @IBOutlet weak var Check_Call: UIButton!
    var previousAddress: String!
    var locationManager = CLLocationManager()
    var previous_Address : String!
    var geoCoder: GMSGeocoder!
    
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    var user_small_pic: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        GMapView.isMyLocationEnabled = true
        GMapView.settings.myLocationButton = true
//        locationManager.startUpdatingLocation()
        geoCoder = GMSGeocoder()
        
        GMapView.delegate = self
        
        
        
        if revealViewController() != nil{
            ButtonBar.target = revealViewController()
            ButtonBar.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }
        
        // burger side bar menu
        self.ref.child("user_profile").child((user?.uid)!).child("profile_pic_small").observe( .value, with:{
            (snapshot) in
            let Dict = snapshot.value as? String?
            print(Dict)
            if(Dict == nil){
                
                print("wait for pic")
            }else{
                let Diction = snapshot.value as! String
                let small_pic = Diction
                print(small_pic)
                self.user_small_pic = small_pic
                print(self.user_small_pic!)
            }
            
        })

    }

    @IBAction func set_Start_Position(_ sender: AnyObject) {
        self.set_location.isHidden = true
        self.Check_Call.isHidden = false
        self.End_position.isHidden = false
        self.commit.isHidden = false
//        let positionMark = CLLocationCoordinate2D(GMSC)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(121, 100)
        marker.title = "Hello World"
        marker.map = GMapView
        
    }
    @IBAction func Check_Call_Motor(_ sender: AnyObject) {
        let NowInterval = NSDate().timeIntervalSince1970
        print(NowInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: NowInterval)
        print(date)
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        print("对应的日期时间：\(dformatter.string(from: date as Date))")
        let nowString = dateFormatter.string(from: date as Date)
        //                nowString = dateFormatter.date(from: nowString)! as NSDate
        print(nowString)
        
        let dateString = DateFormatter.localizedString(from: Date() , dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        print("formatted date is =  \(dateString)")
        let MapMotorPoint = [ // 2
            "startpoint": (Start_position.text)! as String,
            "endpoint":(End_position.text)! as String,
            "commit":(commit.text)! as String,
            "mode":"配對中",
            "time": NowInterval ,
            "distance":"無",
            "picture": user_small_pic!
            ] as [String : Any]
        ref.child("Call_Moto").child((user?.uid)!).child("all").childByAutoId().setValue(MapMotorPoint)
        ref.child("Call_Moto").child((user?.uid)!).child("wait").childByAutoId().setValue(MapMotorPoint)
    }
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 20)
        GMapView.isMyLocationEnabled = true
        GMapView.settings.myLocationButton = true
        GMapView.camera = camera
        locationManager.stopUpdatingLocation()
        
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition){
        reverseGeocodeCoordinate(coordinate: position.target)
            }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        // 1
//        let geoCoder = GMSGeocoder()

//        geoCoder.
        if(self.set_location.isHidden == false)
        {
            
        // 2
        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let addresss = response?.firstResult() {
                
                // 3
                let lines = addresss.lines
                let addd = lines?.joined(separator: "\n")
                self.Start_position.text = addd
                print(addd!)
                // 4
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        }
       else{
        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let addresss = response?.firstResult() {
                
                // 3
                let lines = addresss.lines
                let addd = lines?.joined(separator: "\n")
                self.End_position.text = addd
                print(addd!)
                // 4
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        
        
        
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
