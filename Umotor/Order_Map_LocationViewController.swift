//
//  Order_Map_LocationViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/28.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON
import Alamofire
class Order_Map_LocationViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var Commition: UILabel!
    @IBOutlet weak var TimeLAB: UILabel!
    @IBOutlet weak var arrival_destination: UIButton!
    @IBOutlet weak var Go_to_Custom: UIButton!
    @IBOutlet weak var arrival_customer: UIButton!
    @IBOutlet weak var check_order_button: UIButton!
    @IBOutlet weak var Custom_Start: UILabel!
    @IBOutlet weak var Custom_End: UILabel!
    @IBOutlet weak var MapView: GMSMapView!
    var Start_latitude: AnyObject?
    var Start_longitude: AnyObject?
    var End_latitude: AnyObject?
    var End_longitude: AnyObject?
    var regandata: AnyObject?
    var User_ID: AnyObject?
    var Order_ID: AnyObject?
    var loggedInUser = FIRAuth.auth()?.currentUser
    var ref = FIRDatabase.database().reference()
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.User_ID = regandata?.object(forKey: "useruid") as AnyObject
        self.Order_ID = regandata?.object(forKey: "orderid") as AnyObject
        let Time_point_value = regandata?.object(forKey: "time") as? Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Time_point_value!)
        self.Custom_Start.text = regandata?.object(forKey: "startpoint") as? String
        self.Custom_End.text = regandata?.object(forKey: "endpoint") as? String
        self.TimeLAB.text = dateFormatter.string(from: date as Date)
        let comFromFIR = regandata?.object(forKey: "commit") as? String
        if(comFromFIR != ""){
        self.Custom_Start.text = comFromFIR
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
        let stlat :String = String(format:"%f", Start_latitude!.doubleValue)
        let stlng :String = String(format:"%f", Start_longitude!.doubleValue)
        let orginal = stlat + "," + stlng
        let edlat :String = String(format:"%f", End_latitude!.doubleValue)
        let edlng :String = String(format:"%f", End_longitude!.doubleValue)
        let destinal = edlat + "," + edlng

        directionAPITest(origin: orginal, destination: destinal)
        // Do any additional setup after loading the view.
    }
    @IBAction func cancel() {
        // your code
        self.navigationItem.hidesBackButton = false
        self.navigationItem.rightBarButtonItem = nil
        self.check_order_button.isHidden = false
        self.Go_to_Custom.isHidden = true
        self.arrival_destination.isHidden = true
        self.arrival_customer.isHidden = true
        let MapMotorPoint = [
            "useruid" : User_ID! ,
            "startpoint": regandata?.object(forKey: "startpoint") as! String,
            "startlatitude": (regandata?.object(forKey: "startlatitude"))! ,
            "startlongitude": (regandata?.object(forKey: "startlongitude"))! ,
            "endlatitude": (regandata?.object(forKey: "endlatitude"))! ,
            "endlongitude": (regandata?.object(forKey: "endlongitude"))! ,
            "endpoint":regandata?.object(forKey: "endpoint") as! String,
            "commit":regandata?.object(forKey: "commit") as! String,
            "mode":"配對中",
            "time": (regandata?.object(forKey: "time"))! ,
            "distance":"無",
            "thedriver":"無",
            "orderid": Order_ID,
            "picture": regandata?.object(forKey: "picture") as! String
            ] as [String : Any]
        ref.child("Call_Moto").child(self.User_ID! as! String).child("wait").child(self.Order_ID! as! String).setValue(MapMotorPoint)
        ref.child("Call_Moto").child(self.User_ID! as! String).child("ing").child(self.Order_ID! as! String).removeValue()
        let newUserData = ["mode":"配對中"]
         let driver_id = ["thedriver":"無"]
        ref.child("Call_Moto").child(self.User_ID! as! String).child("all").child(self.Order_ID! as! String).updateChildValues(newUserData)
        ref.child("Call_Moto").child(self.User_ID! as! String).child("all").child(self.Order_ID! as! String).updateChildValues(driver_id)
        
    }
    
    @IBAction func Checking_Order(_ sender: Any) {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"取消載客", style: UIBarButtonItemStyle.plain, target: self , action: #selector(FIRStorageTaskManagement.cancel))
        self.check_order_button.isHidden = true
        self.Go_to_Custom.isHidden = false
        let MapMotorPoint = [
            "useruid" : User_ID! ,
            "startpoint": regandata?.object(forKey: "startpoint") as! String,
            "startlatitude": (regandata?.object(forKey: "startlatitude"))! ,
            "startlongitude": (regandata?.object(forKey: "startlongitude"))! ,
            "endlatitude": (regandata?.object(forKey: "endlatitude"))! ,
            "endlongitude": (regandata?.object(forKey: "endlongitude"))! ,
            "endpoint":regandata?.object(forKey: "endpoint") as! String,
            "commit":regandata?.object(forKey: "commit") as! String,
            "mode":"進行中",
            "time": (regandata?.object(forKey: "time"))! ,
            "distance":"無",
            "thedriver": (loggedInUser?.uid)!,
            "orderid": Order_ID!,
            "picture": regandata?.object(forKey: "picture") as! String
            ] as [String : Any]
        let newUserData = ["mode":"進行中"]
        let driver_id = ["thedriver":(loggedInUser?.uid)!]
        ref.child("Call_Moto").child(self.User_ID! as! String).child("ing").child(self.Order_ID! as! String).setValue(MapMotorPoint)
        ref.child("Call_Moto").child(self.User_ID! as! String).child("wait").child(self.Order_ID! as! String).removeValue()
        ref.child("Call_Moto").child(self.User_ID! as! String).child("all").child(self.Order_ID! as! String).updateChildValues(newUserData)
        ref.child("Call_Moto").child(self.User_ID! as! String).child("all").child(self.Order_ID! as! String).updateChildValues(driver_id)
//        let 
        ref.child("user_profile").child((self.loggedInUser?.uid)!).child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            let dict = snapshot.value as? NSDictionary
            for(_, friendUID) in dict!{
                print(friendUID as! String)
                print(self.User_ID! as! String)
                if(friendUID as! String == self.User_ID! as! String){
                    break
                }
                else{
                    self.ref.child("user_profile").child(self.User_ID! as! String).child("friends").childByAutoId().setValue((self.loggedInUser?.uid)!)
                    self.ref.child("user_profile").child((self.loggedInUser?.uid)!).child("friends").childByAutoId().setValue(self.User_ID! as! String)
                
                }
            }
        })
        
    }
    
    
    
    @IBAction func Arrivied_Custom(_ sender: Any) {
        self.arrival_customer.isHidden = true
        self.arrival_destination.isHidden = false
    }
    @IBAction func Arrivied_Dest(_ sender: Any) {
        let MapMotorPoint = [
            "useruid" : User_ID! ,
            "startpoint": regandata?.object(forKey: "startpoint") as! String,
            "startlatitude": (regandata?.object(forKey: "startlatitude"))! ,
            "startlongitude": (regandata?.object(forKey: "startlongitude"))! ,
            "endlatitude": (regandata?.object(forKey: "endlatitude"))! ,
            "endlongitude": (regandata?.object(forKey: "endlongitude"))! ,
            "endpoint":regandata?.object(forKey: "endpoint") as! String,
            "commit":regandata?.object(forKey: "commit") as! String,
            "mode":"已完成",
            "time": (regandata?.object(forKey: "time"))! ,
            "distance":"無",
            "thedriver": (loggedInUser?.uid)!,
            "orderid": Order_ID,
            "picture": regandata?.object(forKey: "picture") as! String
            ] as [String : Any]
        let newUserData = ["mode":"已完成"]

        ref.child("Call_Moto").child(self.User_ID! as! String).child("finished").child(self.Order_ID! as! String).setValue(MapMotorPoint)
        ref.child("Call_Moto").child(self.User_ID! as! String).child("ing").child(self.Order_ID! as! String).removeValue()
        ref.child("Call_Moto").child(self.User_ID! as! String).child("all").child(self.Order_ID! as! String).updateChildValues(newUserData)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Go_take_custom(_ sender: Any) {
  self.Go_to_Custom.isHidden = true
    self.arrival_customer.isHidden = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func GeocoderAddressToPosition(address: String){
    
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address , completionHandler: {
            (placemarks,error) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            if placemarks != nil && (placemarks?.count)! > 0{
                let placemark = (placemarks?[0])! as CLPlacemark
               let MarkPosition = placemark.location?.coordinate
                //placemark.location.coordinate 取得經緯度的參數            
            }
        })
    }

    func directionAPITest(origin: String!, destination: String!) {
        var directionsURLString = baseURLDirections + "origin=" + origin + "&destination=" + destination
        
        directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        Alamofire.request(directionsURLString).responseJSON
            { response in
                print(response.request)  // original URL request
                print(response.response) // HTTP URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                if let dictionary: NSDictionary = response.result.value  as? NSDictionary {
                    print("JSON: \(dictionary)")
                    let parsedData = JSON(response.result.value!)
                    let status = dictionary["status"] as! String
                    if status == "OK" {
                        let routes = dictionary["routes"] as! [NSDictionary]
                        print(routes)
                        let path = GMSPath.init(fromEncodedPath: (parsedData["routes"][0]["overview_polyline"]["points"].string)!)
                        let distance = (parsedData["routes"][0]["legs"][0]["distance"]["value"].intValue)
                        print(distance)
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 5
                        singleLine.geodesic = true
                        singleLine.map = self.MapView
                    }
                }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
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
