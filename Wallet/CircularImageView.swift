//
//  CircularImageView.swift
//  Wallet
//
//  Created by Service Ontario on 2017-02-22.
//  Copyright © 2017 Service Ontario. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    required init?(coder aDecoder: NSCoder) {
      //  fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
     //   print("cir img view init code")
        baseInit()
    }


    required override init(frame: CGRect) {
        super.init(frame: frame)
    //    print("cir img view init frame")
        baseInit()
    }

/*
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded();
        
        baseInit()
    }
*/
    func baseInit() {
        let imgW: CGFloat = self.bounds.size.width
        self.layer.cornerRadius = imgW / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.clipsToBounds = true
    }
}
