
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
import GooglePlaces
import CoreLocation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SwiftyJSON
import NetworkExtension
import FirebaseInstanceID
import AFNetworking
import Alamofire
import SVProgressHUD
import KumulosSDK


class GoogleMap_EXMPLE_ViewController: UIViewController,UISearchBarDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,GMSAutocompleteViewControllerDelegate{

    @IBOutlet weak var Start_position: UITextField!
    @IBOutlet weak var GMapView: GMSMapView!
    @IBOutlet weak var ButtonBar: UIBarButtonItem!
    @IBOutlet weak var End_position: UITextField!
    @IBOutlet weak var Price_label: UILabel!
    
    @IBOutlet weak var Check: UIButton!
    @IBOutlet weak var Center_icon: UIImageView!
    @IBOutlet weak var commit: UITextField!
    @IBOutlet weak var set_location: UIButton!
    @IBOutlet weak var Check_Call: UIButton!
    var previousAddress: String!
    var locationManager = CLLocationManager()
    var previous_Address : String!
    var geoCoder: GMSGeocoder!
    var Start_latitude: AnyObject?
    var Start_longitude: AnyObject?
    var End_latitude: AnyObject?
    var End_longitude: AnyObject?
    var ref = FIRDatabase.database().reference()
    var user = FIRAuth.auth()?.currentUser
    var user_small_pic: String?
    var finishCAll = 0
    var PA: CLLocationCoordinate2D?
    var PB: CLLocationCoordinate2D?
    var regional: String!
    var destional: String!
    var OrderIDs: String!
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var ModeType : NSDictionary?
//    var NowInterval: AnyObject?
  
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 20)
        
        self.GMapView.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error Complete \(error)")
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
        //取消搜尋
    }
    func dismissKeyboard(){
        commit.resignFirstResponder()
    }
    @IBAction func SearchGMPlace(_ sender: Any) {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        self.present(searchController, animated: true, completion: nil)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField != commit{
        let AutosearchController = GMSAutocompleteViewController()
        AutosearchController.delegate = self
        self.present(AutosearchController, animated: true, completion: nil)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commit.resignFirstResponder()
        return true
    }
    @IBAction func CommitEnd(_ sender: Any) {
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        SVProgressHUD.show()
        let installId = Kumulos.installId
        print("installId: \(installId)")
        ref.child("user_profile").child((user?.uid)!).child("install_id").setValue(installId)
        Start_position.delegate = self
        End_position.delegate = self
        commit.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        GMapView.isMyLocationEnabled = true
        GMapView.settings.myLocationButton = true
        geoCoder = GMSGeocoder()
        GMapView.delegate = self
        self.ButtonBar.tintColor = UIColor.black
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
//        SVProgressHUD.dismiss()
        if revealViewController() != nil{
            ButtonBar.target = revealViewController()
            ButtonBar.action = #selector(SWRevealViewController.revealToggle(_:))
        }
        // burger side bar menu
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GoogleMap_EXMPLE_ViewController.dismissKeyboard)))
            print((user?.uid)!)
        self.ref.child("user_profile").child((user?.uid)!).child("profile_pic_small").observe( .value, with:{
            (snapshot) in
            let Dict = snapshot.value as? String?
            print((self.user?.uid)!)
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
    func ResetPoint(){
        self.set_location.isHidden = false
        self.Check_Call.isHidden = true
        self.End_position.isHidden = true
        self.commit.isHidden = true
        self.navigationItem.rightBarButtonItem = nil

        Center_icon.image = UIImage(named: "google-location-icon-Location_marker_pin_map_gps")
        GMapView.clear()
    }

    @IBAction func set_Start_Position(_ sender: AnyObject) {
        self.set_location.isHidden = true
        self.Check_Call.isHidden = false
        self.End_position.isHidden = false
        self.commit.isHidden = false
        let marker = GMSMarker()
        marker.position = GMapView.camera.target
        marker.title = "Srart_Point"
        marker.icon = UIImage(named: "google-location-icon-Location_marker_pin_map_gps")
        marker.map = self.GMapView
        Start_latitude = GMapView.camera.target.latitude as AnyObject?
        Start_longitude = GMapView.camera.target.longitude as AnyObject?
        let sltatitude :String = String(format:"%f", GMapView.camera.target.latitude)
        let slongitude :String = String(format:"%f", GMapView.camera.target.longitude)
        regional = sltatitude + "," + slongitude
        Center_icon.image = UIImage(named: "End_point_icon")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"重設", style: UIBarButtonItemStyle.plain, target: self , action: #selector(ResetPoint))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        
    }
    @IBAction func Check_Call_Motor(_ sender: AnyObject) {
        let marker = GMSMarker()
        marker.position = GMapView.camera.target
        marker.title = "End_Point"
        marker.icon = UIImage(named: "End_point_icon")
        marker.map = self.GMapView
        End_latitude = GMapView.camera.target.latitude as AnyObject?
        End_longitude = GMapView.camera.target.longitude as AnyObject?
        Check_Call.isHidden = true
        Price_label.isHidden = false
        Check.isHidden = false
        Center_icon.isHidden = true
        let eltatitude :String = String(format:"%f", GMapView.camera.target.latitude)
        let elongitude :String = String(format:"%f", GMapView.camera.target.longitude)
        destional = eltatitude + "," + elongitude
        self.finishCAll = 1
        directionAPITest(origin:  regional , destination: destional)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"重設", style: UIBarButtonItemStyle.plain, target: self , action: #selector(resetpoint_1))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black

    }
    func resetpoint_1(){
//        Check_Call.isHidden = false
        self.set_location.isHidden = false
        Price_label.isHidden = true
        Check.isHidden = true
        Center_icon.isHidden = false
        self.End_position.isHidden = true
        self.commit.isHidden = true
        self.finishCAll = 0
        self.navigationItem.rightBarButtonItem = nil
        Center_icon.image = UIImage(named: "google-location-icon-Location_marker_pin_map_gps")
        GMapView.clear()
        print("123")
    
    }
    func showAlertToComplete(alert: String!){
        let myAlert = UIAlertController(title: "請設定完整地址訊息！", message: alert, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
            print("ok")
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    @IBAction func Check_to_Call(_ sender: AnyObject) {
        if Start_position.text == ""{showAlertToComplete(alert: "請設定乘車位置！")}
        else if End_position.text == ""{showAlertToComplete(alert: "請設定目的地！")}
        else {
        sendNotificationToUser()
        self.Check.isEnabled = false
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
        print(nowString)
        let dateString = DateFormatter.localizedString(from: Date() , dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        print("formatted date is =  \(dateString)")
        let OrderUID = ref.child("Call_Moto").child((user?.uid)!).child("all").childByAutoId().key
        OrderIDs = OrderUID
        let MapMotorPoint = [
            "useruid" : ((user?.uid)!),
            "startpoint": (Start_position.text)! as String,
            "startlatitude":Start_latitude!,
            "startlongitude":Start_longitude!,
            "endlatitude":End_latitude!,
            "endlongitude":End_longitude!,
            "endpoint":(End_position.text)! as String,
            "commit":(commit.text)! as String,
            "mode":"配對中",
            "time": NowInterval ,
            "distance": Price_label.text!,
            "thedriver":"無",
            "orderid": OrderUID,
            "picture": user_small_pic!
            ] as [String : Any]
        ref.child("Call_Moto").child((user?.uid)!).child("all").child(OrderUID).setValue(MapMotorPoint)
        ref.child("Call_Moto").child((user?.uid)!).child("wait").child(OrderUID).setValue(MapMotorPoint)
        
        SVProgressHUD.show(withStatus: "配對中")
        self.GMapView.isUserInteractionEnabled = false
        self.ButtonBar.isEnabled = false
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"取消", style: UIBarButtonItemStyle.plain, target: self , action: #selector(stopCall))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black

        ref.child("Call_Moto").child((user?.uid)!).child("all").child(OrderUID).observe(.value, with: {(snapshot) in
        self.ModeType = snapshot.value as? NSDictionary
            if self.ModeType != nil {
                let call_Mode = self.ModeType?.object(forKey: "mode") as! String
                if call_Mode != "配對中"{
                    SVProgressHUD.showSuccess(withStatus: "配對成功")
                    self.GMapView.isUserInteractionEnabled = true
                    self.ButtonBar.isEnabled = true
                
                    let revealViewControl = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = revealViewControl
                }
            }
        
        })
        }
    }
    func stopCall(){
        SVProgressHUD.dismiss()
        self.GMapView.isUserInteractionEnabled = true
        self.ButtonBar.isEnabled = true
        self.Check.isEnabled = true
//         ref.removeAllObservers()
        let NowInterval = NSDate().timeIntervalSince1970
        let newUserData = ["mode":"已取消"]
//      let MapMotorInfo = MapMotorInforSet(Mode: "已取消", Driver_id: "無")
        let MapMotorPoint = [
            "useruid" : ((user?.uid)!),
            "startpoint": (Start_position.text)! as String,
            "startlatitude":Start_latitude!,
            "startlongitude":Start_longitude!,
            "endlatitude":End_latitude!,
            "endlongitude":End_longitude!,
            "endpoint":(End_position.text)! as String,
            "commit":(commit.text)! as String,
            "mode":"已取消",
            "time": NowInterval ,
            "distance": Price_label.text!,
            "thedriver":"無",
            "orderid": OrderIDs,
            "picture": user_small_pic!
            ] as [String : Any]
         ref.child("Call_Moto").child((user?.uid)!).child("all").child(OrderIDs).updateChildValues(newUserData)
         ref.child("Call_Moto").child((user?.uid)!).child("cancel").child(OrderIDs).setValue(MapMotorPoint)
        self.Check.isEnabled = true
        ref.child("Call_Moto").child((user?.uid)!).child("wait").child(OrderIDs).removeValue()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"重設", style: UIBarButtonItemStyle.plain, target: self , action: #selector(resetpoint_1))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
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
        if(self.finishCAll == 0){
            reverseGeocodeCoordinate(coordinate: position.target)
        }
            }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
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
    func count_price(meter: Int){
        var TatalPrice: Int?
        if(meter <= 500){
            TatalPrice = 35
            self.Price_label.text = "NT:" + String(describing: TatalPrice!)
        }
        else{
            TatalPrice = 35 + (meter - 500) / 250 * 5
            self.Price_label.text =  "NT:" + String(describing: TatalPrice!)
        
        }
    
    }
    func sendNotificationToUser()
    {//Push notifivation http request
        let url = URL(string: "https://push.kumulos.com/notifications")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let username = "30ef3730-4f04-4af0-9ea0-075bff8d9e97"
        let password = "dfPdrsuT6r2Dkkh2XKuO/KKghWPa7H+F4aaN"
        let loginString = "\(username):\(password)"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        // -u
        
        //let dictionary:[String:Any] = ["broadcast": true, "title":"新訂單訊息", "message":"附近有人丟出訂單，開啟您的司機模式接單吧！"]
        
        let dictionary:[String:Any] = ["broadcast": true, "title":"新訂單訊息", "message":"附近有人丟出訂單，開啟您的司機模式接單吧！"]
        

        
        
        do {
            let data = try  JSONSerialization.data(withJSONObject: dictionary, options: [])
            let task = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { (data, response, err) in
                        print("erraaaa \(err.debugDescription)")
                
            
                })
                task.resume()
            }
        catch {
        
        }
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
                        let distance = (parsedData["routes"][0]["legs"][0]["distance"]["value"].intValue)
                        print(distance)
                        self.count_price(meter: distance)
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 5
                        singleLine.geodesic = true
                        singleLine.map = self.GMapView
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
