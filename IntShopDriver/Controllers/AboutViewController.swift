//
//  AboutViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/30/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, SFSafariViewControllerDelegate {
    
    let urlString = "https://www.intshop.com"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func GoBack(_ sender: UIButton) {
        
        let  vc =  self.navigationController?.viewControllers.filter({$0 is AccountViewController}).first
        self.navigationController?.popToViewController(vc!, animated: true)
        
    }
    @IBAction func VisitSite(_ sender: UIButton) {
        
        let svc = SFSafariViewController(url: NSURL(string: self.urlString)! as URL)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    {
        controller.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
