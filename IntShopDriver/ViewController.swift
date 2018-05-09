//
//  ViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/24/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: Layout variables.
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    var success: String = ""
    
    //MARK: Location Manager - CoreLocation Framework.
    var locationManager = CLLocationManager()
    
    //MARK: Current location information
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
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
        
        //MARK: Authorization for utilization of location services for background process
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            // Location Manager configuration
            locationManager.delegate = self
            
            // Location Accuracy, properties
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.allowsBackgroundLocationUpdates = true
            
            locationManager.startUpdatingLocation()
            
        }
        
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        if SharingManager.sharedInstance.create {
            SharingManager.sharedInstance.create = false
            print("Success")
            self.view.layer.removeAllAnimations()
            self.view.layer.add(presentationAnimation, forKey: "present")
        }
        
    }
    
    @IBAction func SignInAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "tab", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "tab" {
            _ = segue.destination as! TabBarViewController            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

//MARK: extension UIColor(hexcolor)
extension UIColor {
    
    // Convert UIColor from Hex to RGB
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
}

extension ViewController: CreateAccountDelegate {
    
    func SuccessfullyCreated(controller: CreateAccountViewController, didsuccessful success: String) {
        self.success = success
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        SharingManager.sharedInstance.currentLoc = locValue
        SharingManager.sharedInstance.currentLocation = "\(locValue.latitude), \(locValue.longitude)"
        print(SharingManager.sharedInstance.currentLoc)
        //        if firstShared {
        //            SharingManager.sharedInstance.uploadingLoc = locValue
        //            SharingManager.sharedInstance.uploadingLocation = "\(locValue.latitude), \(locValue.longitude)"
        //            firstShared = false
        //        }
        
    }
}

