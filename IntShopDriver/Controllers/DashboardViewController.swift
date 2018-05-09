//
//  DashboardViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import CoreLocation

class DashboardViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    
    
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.view.layer.removeAllAnimations()
        self.view.layer.add(presentationAnimation, forKey: "present")
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
        
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Go back to map", style: .plain, target: nil, action: nil)
    }
    
    
    @IBAction func GoOnlineAction(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "map", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "delivery" {
            _ = segue.destination as! DeliveryViewController
            SharingManager.sharedInstance.gotoDeliver = true
        }else {
            _ = segue.destination as! MapViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "delivery", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashboard", for: indexPath) as! DashboardCell
        
        cell.distance.text = "4,03"
        cell.address.text = "sisco"
        cell.cellBtn.setTitle("VIEW", for: .normal)
        cell.close.isHidden = true
        cell.duration.text = "35"
        
        return cell
        
    }
}

