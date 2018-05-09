//
//  RatingViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import AXRatingView

class RatingViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let userNames = ["Jone Doe", "Jorge Almeida", "Ann Spinnola", "Phillip Larm"]
    let ratings = [4, 5, 3, 3.5]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

extension RatingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath) as! RatingCell
        
        cell.userName.text = self.userNames[indexPath.row]
        cell.signDate.text = "28/06/2016"
        cell.ratingView.sizeToFit()
        cell.ratingView.isUserInteractionEnabled = false
        cell.ratingView.value = Float(self.ratings[indexPath.row])
        cell.ratingView.baseColor = UIColor.lightGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
