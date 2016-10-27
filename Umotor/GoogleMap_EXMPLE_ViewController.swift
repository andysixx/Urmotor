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

class GoogleMap_EXMPLE_ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{

    @IBOutlet weak var GMapView: GMSMapView!
    var locationManager = CLLocationManager()
    var previousAddress: String!
    var geoCoder: GMSGeocoder!
//    let dataProvider : GoogleDataPr
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        geoCoder = GMSGeocoder()
        GMapView.delegate = self
    }


    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 100)
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
        let geoCoder = GMSGeocoder()
        
        // 2
        geoCoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let addresss = response?.firstResult() {
                
                // 3
                let lines = addresss.lines
                let addd = lines?.joined(separator: "\n")
//                self.addressLabel.text = lines.joinWithSeparator("\n")
                print(addd!)
                // 4
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
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
