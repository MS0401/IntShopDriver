//
//  NewPasswordController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/31/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class NewPasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BackToLogin(_ sender: UIButton) {
        
//        self.dismiss(animated: true, completion: nil)
        let  vc =  self.navigationController?.viewControllers.filter({$0 is ViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
    }

    

}
