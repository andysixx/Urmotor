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
import SVProgressHUD

class Order_Map_LocationViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var Commition: UILabel!
    @IBOutlet weak var TimeLAB: UILabel!
    @IBOutlet weak var arrival_destination: UIButton!
    @IBOutlet weak var Go_to_Custom: UIButton!
    @IBOutlet weak var arrival_customer: UIButton!
    @IBOutlet weak var Chat_To_Custom: UIButton!
    @IBOutlet weak var check_order_button: UIButton!
    @IBOutlet weak var Custom_Start: UILabel!
    @IBOutlet weak var Custom_End: UILabel!
    @IBOutlet weak var MapView: GMSMapView!
    var Start_latitude: AnyObject?
    var Start_longitude: AnyObject?
    var End_latitude: AnyObject?
    var End_longitude: AnyObject?
    var regandata: AnyObject?
    var Custom_ID: AnyObject?
    var Order_ID: AnyObject?
    var Install_ids: String!
    var MotoNumber: String!
    
    var loggedInUser = FIRAuth.auth()?.currentUser
    var ref = FIRDatabase.database().reference()
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    override func viewDidLoad() {
        super.viewDidLoad()
        BuildMapLoad()
        // Do any additional setup after loading the view.
    }
    func BuildMapLoad(){
        SVProgressHUD.show()
        self.Chat_To_Custom.isEnabled = false
        self.Custom_ID = regandata?.object(forKey: "useruid") as AnyObject
        self.Order_ID = regandata?.object(forKey: "orderid") as AnyObject
        let Time_point_value = regandata?.object(forKey: "time") as? Double
        self.regandata?.setValue(self.Custom_ID, forKey: "uid")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Time_point_value!)
        self.Custom_Start.text = regandata?.object(forKey: "startpoint") as? String
        self.Custom_End.text = regandata?.object(forKey: "endpoint") as? String
        self.TimeLAB.text = dateFormatter.string(from: date as Date)
        let comFromFIR = regandata?.object(forKey: "commit") as? String
        if(comFromFIR != ""){
            self.Commition.text = comFromFIR
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
        getinstallIDs()
        GetMotoNumber()
        SVProgressHUD.dismiss()
    }
    func GetMotoNumber(){
        ref.child("user_profile").child((loggedInUser?.uid)!).child("driver_info").child("motor_number").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.value != nil{
            self.MotoNumber = snapshot.value as! String
            }
        })
    
    }
    func getinstallIDs(){
        ref.child("user_profile").child(Custom_ID as! String).child("install_id").observeSingleEvent(of: .value, with: {(snapshot) in
            self.Install_ids = snapshot.value as! String
        
        })
    
    }
    @IBAction func cancel() {
        // your code
        CancelReasonAlert()
        
    }
    func FirupdateSetValue(set_Value: [String : Any], Child_Type: String){
        ref.child("Call_Moto").child(self.Custom_ID! as! String).child(Child_Type).child(self.Order_ID! as! String).setValue(set_Value)
    }
    func FirRemoveValue(Child_Type: String){
        ref.child("Call_Moto").child(self.Custom_ID! as! String).child(Child_Type).child(self.Order_ID! as! String).removeValue()
    }
    func FirupdateChildValue(UpdateValue: [String:String],Child_Type: String){
        ref.child("Call_Moto").child(self.Custom_ID! as! String).child(Child_Type).child(self.Order_ID! as! String).updateChildValues(UpdateValue)
    
    }
    
    @IBAction func Checking_Order(_ sender: Any) {
        ref.child("Call_Moto").child(self.Custom_ID! as! String).child("all").child(self.Order_ID! as! String).child("thedriver").childByAutoId().setValue(self.loggedInUser?.uid , withCompletionBlock: {(err,snapshot) in
            self.ref.child("Call_Moto").child(self.Custom_ID! as! String).child("all").child(self.Order_ID! as! String).child("thedriver").observeSingleEvent(of: .childAdded, with: {(snapshot) in
                
                let objectDic = snapshot.value as! String
                if objectDic == self.loggedInUser?.uid{
                    SVProgressHUD.showSuccess(withStatus: "成功接單")
                    print("youcandirve")
                    self.navigationItem.hidesBackButton = true
                    self.Chat_To_Custom.isHidden = false
                    self.Chat_To_Custom.isEnabled = true
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"取消載客", style: UIBarButtonItemStyle.plain, target: self , action: #selector(FIRStorageTaskManagement.cancel))
                    self.check_order_button.isHidden = true
                    self.Go_to_Custom.isHidden = false
                    let MapMotorPoint = self.MapMotorInforSet(Mode: "進行中", Driver_id: (self.loggedInUser?.uid)!)
                    let newUserData = ["mode":"進行中"]
                    let driver_id = ["thedriver":(self.loggedInUser?.uid)! as String]
                    self.FirupdateSetValue(set_Value: MapMotorPoint, Child_Type: "ing")
                    self.FirRemoveValue(Child_Type: "wait")
                    self.FirupdateChildValue(UpdateValue: newUserData, Child_Type: "all")
                    self.FirupdateChildValue(UpdateValue: driver_id, Child_Type: "all")
                    self.checkFriendIs()
                    print(self.MotoNumber)
                    self.sendNotificationToUser(DisplayName: "配對成功", text: "司機的車號為:\(self.MotoNumber!)", InstallIDs: self.Install_ids)
                
                }else
                {
                    SVProgressHUD.showError(withStatus: "訂單已被接走！")
                    print("you cannt")
                    self.navigationController?.popViewController(animated: true)
                    return
                
                }
            })
        
        })
        
    }
    func checkFriendIs(){
        
        ref.child("user_profile").child((self.loggedInUser?.uid)!).child("friends").observeSingleEvent(of: .value, with: {
            (snapshot) in
            let dict = snapshot.value as? [String:String]
            let result = dict?.values.contains { (value) -> Bool in
                            if value == self.Custom_ID as! String{
                                return true
                            }
                            else {
                                return false
                            }
                        }
            if result ==  false{
                self.ref.child("user_profile").child(self.Custom_ID! as! String).child("friends").childByAutoId().setValue((self.loggedInUser?.uid)!)
                
                
                self.ref.child("user_profile").child((self.loggedInUser?.uid)!).child("friends").childByAutoId().setValue(self.Custom_ID! as! String)
            
            }
        })

    
    }
    
    
    @IBAction func Arrivied_Custom(_ sender: Any) {
        self.arrival_customer.isHidden = true
        self.arrival_destination.isHidden = false
        self.sendNotificationToUser(DisplayName: "司機已抵達您的位置！", text: "司機已抵達您的位置！", InstallIDs: self.Install_ids)
    }
    func MapMotorInforSet(Mode: String, Driver_id: String) -> [String : Any] {
        let MapMotor_Point = [
            "useruid" : Custom_ID! ,
            "startpoint": regandata?.object(forKey: "startpoint") as! String,
            "startlatitude": (regandata?.object(forKey: "startlatitude"))! ,
            "startlongitude": (regandata?.object(forKey: "startlongitude"))! ,
            "endlatitude": (regandata?.object(forKey: "endlatitude"))! ,
            "endlongitude": (regandata?.object(forKey: "endlongitude"))! ,
            "endpoint":regandata?.object(forKey: "endpoint") as! String,
            "commit":regandata?.object(forKey: "commit") as! String,
            "mode":Mode,
            "time": (regandata?.object(forKey: "time"))! ,
            "distance":regandata?.object(forKey: "distance") as! String,
            "thedriver": Driver_id,
            "orderid": Order_ID!,
            "picture": regandata?.object(forKey: "picture") as! String
            ] as [String : Any]
        return MapMotor_Point
    }
    @IBAction func Arrivied_Dest(_ sender: Any) {
        
        let MapMotorPoint = MapMotorInforSet(Mode: "已完成", Driver_id: (self.loggedInUser?.uid)!)
        let newUserData = ["mode":"已完成"]
        FirupdateChildValue(UpdateValue: newUserData, Child_Type: "all")
        FirupdateSetValue(set_Value: MapMotorPoint, Child_Type: "finished")
        FirRemoveValue(Child_Type: "ing")
        self.sendNotificationToUser(DisplayName: "已完成訂單", text: "期待您下次再次叫車！", InstallIDs: self.Install_ids)
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Go_take_custom(_ sender: Any) {
  self.Go_to_Custom.isHidden = true
    self.arrival_customer.isHidden = false
        self.sendNotificationToUser(DisplayName: "司機將準備前往您的目的地！", text: "司機將準備前往您的目的地！", InstallIDs: self.Install_ids)
    }
    
    func CancelReasonAlert(){
        let alertController = UIAlertController(title: "確定取消載客？", message: "請說明取消理由！", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Login"
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "確定", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.navigationItem.hidesBackButton = false
            self.navigationItem.rightBarButtonItem = nil
            self.check_order_button.isHidden = false
            self.Go_to_Custom.isHidden = true
            self.arrival_destination.isHidden = true
            self.arrival_customer.isHidden = true
            let MapMotorPoint = self.MapMotorInforSet(Mode: "配對中", Driver_id: "無")
            self.FirupdateSetValue(set_Value: MapMotorPoint, Child_Type: "wait")
            self.FirRemoveValue(Child_Type: "ing")
            let newUserData = ["mode":"配對中"]
            let driver_id = ["thedriver":"無"]
            self.FirupdateChildValue(UpdateValue: newUserData, Child_Type: "all")
            self.FirupdateChildValue(UpdateValue: driver_id, Child_Type: "all")
            let CancelReasonString = alertController.textFields?.first?.text
            self.sendNotificationToUser(DisplayName: "司機已取消訂單，等待下位司機接單！", text: CancelReasonString!, InstallIDs: self.Install_ids)
//            print(alertController.textFields?.first?.text!)
//            print("123")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
                print(error!)
                return
            }
            
            if placemarks != nil && (placemarks?.count)! > 0{
                let placemark = (placemarks?[0])! as CLPlacemark
               _ = placemark.location?.coordinate
                //placemark.location.coordinate 取得經緯度的參數            
            }
        })
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
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 5
                        singleLine.geodesic = true
                        singleLine.map = self.MapView
                    }
                }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderChatCustom"{
            let navVC = segue.destination as! ChatViewController
            navVC.senderId = self.loggedInUser?.uid
            navVC.receiverData = regandata
            navVC.senderDisplayName = "聯絡司機"
        }

    }
    func sendNotificationToUser(DisplayName: String!, text: String!, InstallIDs: String!)
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
        let dictionary:[String:Any] = ["broadcast": false, "title":DisplayName, "message":text, "installIds":[InstallIDs]]
        
        
        
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
