//
//  DeliveryViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class DeliveryViewController: UIViewController {
    
    
    @IBOutlet var mapView: GMSMapView!
    
    //MARK: GoogleMap and Core Location initialize.
    var locationManager = CLLocationManager()
    //    var mapTasks = MapTasks()
    
    var tappingAddress: [String] = [String]()
    
    var locationMarker: GMSMarker!
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var usersMarker = [GMSMarker]()
    var markerposition: CLLocationCoordinate2D!
    
    //MARK: Current location information
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var currentCameraCoordinate: CLLocationCoordinate2D!
    
    var routePolyline: GMSPolyline!
    var arrPolylineAdded: [GMSPolyline] = [GMSPolyline]()
    var arrPolylinesingle: [GMSPolyline] = [GMSPolyline]()
    var circleRouteArray: [GMSCircle] = [GMSCircle]()
    
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: mapView delegate.
        mapView.delegate = self
        
        //MARK: Appdelegate property
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        
        //MARK: clear mapview
        mapView.clear()
        
        locationManager.delegate = self
        
        //MARK: Gets the exact location of the user.(for region monitoring)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //MARK: Request permission to use Location service
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
        
        //MARK: Start the update of user's Location
        locationManager.startUpdatingLocation()
        
        //MARK: Set compass of map view
        mapView.settings.compassButton = true
        
        //MARK: Start the update of user's Location
        if CLLocationManager.locationServicesEnabled() {
            
            //MARK: Location Accuracy, properties
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
            
            locationManager.startUpdatingLocation()
            
            print(SharingManager.sharedInstance.currentLoc)
            self.currentCameraCoordinate = SharingManager.sharedInstance.currentLoc
            let camera = GMSCameraPosition.camera(withLatitude: (self.currentCameraCoordinate.latitude), longitude: (self.currentCameraCoordinate.longitude), zoom: 9)
            self.mapView.animate(to: camera)
            self.setuplocationMarker(self.currentCameraCoordinate)
        }
    }
    
    // Set Current Location Marker
    func setuplocationMarker(_ coordinate: CLLocationCoordinate2D) {
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        locationMarker.opacity = 0.85
        locationMarker.title = "main"
        locationMarker.icon = UIImage(named: "mapFlag")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        SharingManager.sharedInstance.gotoDeliver = false

        
    }
    @IBAction func GoBackToMap(_ sender: UIButton) {
        
        if SharingManager.sharedInstance.gotoDeliver {
            
            let  vc =  self.navigationController?.viewControllers.filter({$0 is DashboardViewController}).first
            self.navigationController?.popToViewController(vc!, animated: true)
        }else {
            let  vc =  self.navigationController?.viewControllers.filter({$0 is MapViewController}).first
            self.navigationController?.popToViewController(vc!, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

//GMSMapViewDelegate method
extension DeliveryViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.markerposition = marker.position
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        
    }
    
}


// MARK: - CLLocationManagerDelegate
extension DeliveryViewController:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        
    }
}

