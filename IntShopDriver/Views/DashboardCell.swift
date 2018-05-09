//
//  DashboardCell.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class DashboardCell: UITableViewCell {
    
    @IBOutlet var cellBtn: UIButton!
    @IBOutlet var duration: UILabel!
    @IBOutlet var minLeft: UILabel!
    @IBOutlet var close: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var address: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.close.isHidden = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
