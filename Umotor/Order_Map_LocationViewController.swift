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
class Order_Map_LocationViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var GMapView: GMSMapView!
    var Start_latitude: AnyObject?
    var Start_longitude: AnyObject?
    var End_latitude: AnyObject?
    var End_longitude: AnyObject?
    var regandata: AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plane, target: nil, action: nil)
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(Start_latitude!.floatValue) , longitude: CLLocationDegrees(Start_longitude!.floatValue), zoom: 17.5)
        GMapView.camera =  camera
        let StartMark = GMSMarker()
        
        StartMark.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(Start_latitude!.floatValue),longitude: CLLocationDegrees(Start_longitude!.floatValue))
        StartMark.title = "乘客起點位置"
        StartMark.map = GMapView
        let Endposition = CLLocationCoordinate2D(latitude: CLLocationDegrees(End_latitude!.floatValue),longitude: CLLocationDegrees(End_longitude!.floatValue))
        let EndMark = GMSMarker(position: Endposition)
        EndMark.title = "乘客目的位置"
        EndMark.map = GMapView
        
        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let camera = GMSCameraPosition.camera(withLatitude: Start_latitude as! CLLocationDegrees , longitude: Start_longitude as! CLLocationDegrees, zoom: 15)
//        GMapView.camera =  camera
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
