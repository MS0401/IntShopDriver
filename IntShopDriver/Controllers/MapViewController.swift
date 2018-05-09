//
//  MapViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class MapViewController: UIViewController {
    
    
    @IBOutlet var showDeliveryConstraint: NSLayoutConstraint!//73
    @IBOutlet var findDeliveryConstraint: NSLayoutConstraint!//58
    @IBOutlet var findDeliverLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var tableView: UITableView!
    
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
    
    //MARK: showing more delivery list
    var moreDeliver: Bool = false
    var i = 0
    var tapGestureRecogniser = UITapGestureRecognizer()
    
    var presentationAnimation: CAAnimationGroup {
        get{
            let fadeAnimation = CABasicAnimation(keyPath: "opacity")
            fadeAnimation.fromValue = 0.0
            fadeAnimation.toValue = 1.0
            fadeAnimation.duration = 0.3
            fadeAnimation.fillMode = kCAFillModeForwards
            
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.toValue = 1.0
            scaleAnimation.fromValue = 0.8
            scaleAnimation.duration = 0.3
            scaleAnimation.fillMode = kCAFillModeForwards
            
            let groupAnimation = CAAnimationGroup()
            groupAnimation.duration = 0.3
            groupAnimation.animations = [fadeAnimation, scaleAnimation]
            groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            return groupAnimation
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(MapViewController.FindMoreDelivery(_:)))
        tapGestureRecogniser.numberOfTapsRequired = 1
        tapGestureRecogniser.numberOfTouchesRequired = 1
        self.findDeliverLabel.addGestureRecognizer(tapGestureRecogniser)
        self.findDeliverLabel.isUserInteractionEnabled = true
        
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
            print(SharingManager.sharedInstance.currentLoc)
            let camera = GMSCameraPosition.camera(withLatitude: (self.currentCameraCoordinate.latitude), longitude: (self.currentCameraCoordinate.longitude), zoom: 12)
            self.mapView.animate(to: camera)
        }
    }
    
    //MARK: view initialize.
    func Initialize() {
        
        self.showDeliveryConstraint.constant = 0
        self.findDeliverLabel.text = "Find delivers..."
        
        self.tableView.isHidden = true
        
        let deadline = DispatchTime.now() + 3.0
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: {
            
            self.showDeliveryConstraint.constant = 73
            self.findDeliverLabel.text = "Find more delivers..."
            self.tableView.isHidden = false
            
        })
    }
    
    func FindMoreDelivery(_ sender: UITapGestureRecognizer) {
        
        if !self.moreDeliver {
            self.moreDeliver = true
            self.findDeliverLabel.isHidden = true
            self.findDeliveryConstraint.constant = 0
            self.showDeliveryConstraint.constant = 150
            self.tableView.reloadData()
        }else {
            self.moreDeliver = false
            self.findDeliveryConstraint.constant = 58
            self.findDeliverLabel.isHidden = false
            self.showDeliveryConstraint.constant = 73
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.i = 0
        
        self.navigationController?.navigationBar.backItem?.title = "Go offline"
        
        //MARK: view transition.
        self.view.layer.removeAllAnimations()
        self.view.layer.add(presentationAnimation, forKey: "present")
        
        self.Initialize()
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.findDeliveryConstraint.constant = 58
        self.findDeliverLabel.isHidden = false
        self.showDeliveryConstraint.constant = 73
        self.moreDeliver = false
    }
    
    
    @IBAction func GoOfflineAction(_ sender: UIButton) {
        
        let  vc =  self.navigationController?.viewControllers.filter({$0 is DashboardViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "delivery" {
            _ = segue.destination as! DeliveryViewController
            
        }
    }

}

//GMSMapViewDelegate method
extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.markerposition = marker.position
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        
    }
    
}


// MARK: - CLLocationManagerDelegate
extension MapViewController:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        
    }
}

extension MapViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.moreDeliver {
            return 8
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "delivery", for: indexPath) as! DeliveryCell
        
        if self.moreDeliver {
            
            self.i = self.i + 1
            cell.deliveryNumber.text = "\(self.i)"
            cell.distance.text = "4,03"
            cell.deliveryaddress.text = "Tesco"
            cell.pickDistance.text = "(1.3km)"
            cell.duration.text = "35"
            
            return cell
        }else {
            cell.deliveryNumber.text = "1"
            cell.distance.text = "4,03"
            cell.deliveryaddress.text = "Tesco"
            cell.pickDistance.text = "(1.3km)"
            cell.duration.text = "35"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "delivery", sender: self)
    }
    
}
