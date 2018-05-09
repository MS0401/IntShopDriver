//
//  SharingManager.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/29/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class SharingManager {
    
    static let sharedInstance = SharingManager()
    
    //Current location
    var currentLocation = ""
    var currentLoc: CLLocationCoordinate2D!
    
    var create: Bool = false
    var gotoDeliver: Bool = false
    
    
}
