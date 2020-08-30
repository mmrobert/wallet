//
//  ServiceItemCell.swift
//  Wallet
//
//  Created by Service Ontario on 2017-02-24.
//  Copyright © 2017 Service Ontario. All rights reserved.
//

import UIKit

class ServiceItemCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImgView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        baseInit()
        
     //   self.contentView.layer.borderColor = UIColor.gray.cgColor
     //   self.contentView.layer.borderWidth = 2
     //   self.contentView.layer.cornerRadius = 10
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        baseInit()
    }
    
    func baseInit() {
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true

    }
}
