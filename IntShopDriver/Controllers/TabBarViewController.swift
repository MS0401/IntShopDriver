//
//  TabBarViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/27/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, WWTabBarDelegate {
    
    var selectedBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let originRect = self.tabBar.frame
//        self.tabBar.removeFromSuperview()
        
        let tabbarView = WWTabBar.init(frame: originRect, increasedHeight: 13)
        tabbarView?.backgroundColor = UIColor.init(netHex: 0x223548)
        tabbarView?.delegate = self
        self.view.addSubview(tabbarView!)
        
        tabbarView?.addButton(with: UIImage(named: "icon-dashboard"), name: "Dashboard", index: 1)
        tabbarView?.addButton(with: UIImage(named: "icon-earning"), name: "Earnings", index: 2)
        tabbarView?.addButton(with: UIImage(named: "icon-rating"), name: "Ratings", index: 3)
        tabbarView?.addButton(with: UIImage(named: "icon-user"), name: "Account", index: 4)
        
        
    }
    
    //MARK: WWTabBar delegate
    func tabBar(_ tabBar: WWTabBar!, selectedFrom from: Int, to: Int) {
        self.selectedIndex = to
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
