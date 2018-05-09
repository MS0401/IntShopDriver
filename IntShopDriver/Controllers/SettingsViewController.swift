//
//  SettingsViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/30/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        
        let  vc =  self.navigationController?.viewControllers.filter({$0 is AccountViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }

    

}
