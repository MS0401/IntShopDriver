//
//  RatingCell.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import AXRatingView

class RatingCell: UITableViewCell {
    
    
    @IBOutlet var btnView: UIView!
    @IBOutlet var ratingView: AXRatingView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var signDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
