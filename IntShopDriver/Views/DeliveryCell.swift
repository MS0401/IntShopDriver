//
//  DeliveryCell.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/30/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class DeliveryCell: UITableViewCell {
    
    @IBOutlet var deliveryNumber: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var deliveryaddress: UILabel!
    @IBOutlet var pickDistance: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet var deliverNumberView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.deliverNumberView.layer.cornerRadius = self.deliverNumberView.frame.size.height/2
        self.deliverNumberView.layer.masksToBounds = true
        self.deliverNumberView.layer.borderWidth = 1.5
        self.deliverNumberView.layer.borderColor = UIColor.init(netHex: 0x3493D5).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
