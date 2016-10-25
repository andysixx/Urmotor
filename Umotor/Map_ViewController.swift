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
class Map_ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate{
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
    var user_small_pic: String?
        @IBAction func Call_car_now(_ sender: AnyObject) {
        self.set_location.isHidden = true
        self.checkdouble.isHidden = false
            self.end_adress.isHidden = false
            self.commition.isHidden = false
            
        
    }
    @IBAction func Check_call_car(_ sender: AnyObject) {
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
//                print(howlong)

        let dateString = DateFormatter.localizedString(from: Date() , dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        print("formatted date is =  \(dateString)")
        let MapMotorPoint = [ // 2
            "startpoint": (Adress.text)! as String,
            "endpoint":(end_adress.text)! as String,
            "commit":(commition.text)! as String,
            "mode":"配對中",
            "time": NowInterval ,
            "distance":"無",
            "picture": user_small_pic!
        ] as [String : Any]
            ref.child("Call_Moto").child((user?.uid)!).child("all").childByAutoId().setValue(MapMotorPoint)
            ref.child("Call_Moto").child((user?.uid)!).child("wait").childByAutoId().setValue(MapMotorPoint)
        
        
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
        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }

        self.MapV.delegate = self
        // burger side bar menu
        self.ref.child("user_profile").child((user?.uid)!).child("profile_pic_small").observe( .value, with:{
            (snapshot) in
            let Dict = snapshot.value as? String?
            print(Dict)
            if(Dict == nil){
            
                print("wait for pic")
            }else{
//            let storage = FIRStorage.storage()
//            
//            let storageRef = storage.reference(forURL: "gs://umotor-7f3dd.appspot.com")
//            let profilePicRef = storageRef.child(self.user!.uid + "profile_pic_small.jpg")
//            
//            
//            //store the user ID
//            let userID = self.user?.uid
//            let databaseRef = FIRDatabase.database().reference()
//            databaseRef.child("user_profile").child((user?.uid)!).child("profile_pic_small").observe( .value, with: {
//                (snapshot) in
//                var profilePic = snapshot.value as? String?
//                var pictake = snapshot.value as? NSDictionary
////                print(profilePic as? NSDictionary)
//                if(profilePic == nil){
//                    if let imageData = NSData(contentsOf: self.user!.photoURL!){
//                        let uploadTask = profilePicRef.put(imageData as Data, metadata: nil){
//                            metadata,error in
//                            if(error == nil){
//                                
//                                let DownloadUrl = metadata!.downloadURL
//                                databaseRef.child("user_profile").child("\(self.user!.uid)/profile_pic_small").setValue(DownloadUrl()!.absoluteString)
//                                
//                            }
//                            else{
//                                
//                                
//                                print("error in download image")
//                                
//                            }
//                        }
//                    }
//                }
//                else{
//                    
//                    let small_pic = pictake as String
//                    
//
//                    print(small_pic)
//
//                
//                }
                let Diction = snapshot.value as! String
                let small_pic = Diction
                print(small_pic)
                self.user_small_pic = small_pic
                print(self.user_small_pic!)
            }

            })
            
            
                        //            return userpicsm
//        })
                // Do any additional setup after loading the view.
    
    
    }
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        
//        textBox.resignFirstResponder()
//        
//    }
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
//    private func textFieldShouldReturn(_ textField: commition) -> Bool {
//        
//        self.view.endEditing(true)
//        
//        return true
//        
//    }
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.view.endEditing(true)
//    }
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
//            print(addrList)
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
