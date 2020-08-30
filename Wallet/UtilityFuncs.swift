//
//  UtilityFuncs.swift
//  Wallet
//
//  Created by Service Ontario on 2017-02-23.
//  Copyright © 2017 Service Ontario. All rights reserved.
//

import UIKit

class UtilityFuncs: NSObject {
    
    static func compressAndResizeImage(imageIn: UIImage, maxWidth: Float, maxHeight: Float, compressionQuality: Float) -> UIImage {
        
        var actualHeight: Float = Float(imageIn.size.height)
        var actualWidth: Float = Float(imageIn.size.width)
     //   var maxHeight: Float = 300.0
     //   var maxWidth: Float = 400.0
        let imgRatio: Float = actualWidth/actualHeight
        let maxRatio: Float = maxWidth/maxHeight
    //    var compressionQuality: Float = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if (imgRatio < maxRatio) {
                // adjust width according to maxHeight
                let reducedRatio = maxHeight/actualHeight
                //     imgRatio = maxHeight/actualHeight;
                actualWidth = reducedRatio * actualWidth
                actualHeight = maxHeight
            } else if (imgRatio > maxRatio) {
                // adjust width according to maxWidth
                let reducedRatio2 = maxWidth/actualWidth
                actualHeight = reducedRatio2 * actualHeight
                actualWidth = maxWidth
            } else {
                actualWidth = maxWidth
                actualHeight = maxHeight
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: Double(actualWidth), height: Double(actualHeight))
        
        UIGraphicsBeginImageContext(rect.size)
        imageIn.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imgData: Data = UIImageJPEGRepresentation(img, CGFloat(compressionQuality))!
        
        UIGraphicsEndImageContext()
        
        return UIImage(data: imgData)!
    }
    
    static func randomColor() -> UIColor {
        let hue: Float = Float(arc4random() % 256) / 256.0 // 0.0 to 1.0
        let saturation: Float = (Float(arc4random() % 128) / 256.0) + 0.4; // 0.5 to 1.0 away from white
        let brightness: Float = (Float(arc4random() % 128) / 256.0) + 0.7; // 0.5 to 1.0 away from black
        
        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1.0)
    }
    
    static func isNumeric(textToCheck: String) -> Bool {
        
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = NumberFormatter.Style.decimal
        
        let numb = formatter.number(from: textToCheck)
        
        if numb != nil {
            return true
        } else {
            return false
        }
        
    }
    
}
