//
//  DailyCell.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/29/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit

class DailyCell: UICollectionViewCell {
    
    @IBOutlet var month: UILabel!
    @IBOutlet var superView: UIView!
    @IBOutlet var subView: UIView!
    @IBOutlet var day: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        
        self.superView.layer.cornerRadius = self.superView.frame.size.height/2
        self.superView.layer.borderWidth = 1.5
        self.superView.layer.borderColor = UIColor.init(netHex: 0x254764).cgColor
        self.superView.layer.masksToBounds = true
        self.superView.backgroundColor = UIColor.clear
        
        self.subView.layer.cornerRadius = self.subView.frame.size.height/2
        self.subView.backgroundColor = UIColor.clear
        self.subView.layer.masksToBounds = true
    }

}
