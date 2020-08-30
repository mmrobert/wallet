//
//  PixellationFilter.swift
//  Wallet
//
//  Created by Service Ontario on 2017-03-13.
//  Copyright © 2017 Service Ontario. All rights reserved.
//

import Foundation
import CoreImage

struct PixellationFilter : Filter {
    let inputImage: CIImage
    var inputFactor: CGFloat
    var inputCenter: CIVector
    
    init(inputImage: CIImage) {
        self.inputImage = inputImage
        self.inputFactor = 20
        
        let inputImageSize = inputImage.extent.size
        self.inputCenter = CIVector(
            x: inputImageSize.width / 2,
            y: inputImageSize.height / 2
        )
    }
    
    var outputImage: CIImage? {
        let inputImageSize = inputImage.extent.size
        let inputScale = max(inputImageSize.width, inputImageSize.height) / inputFactor
        return inputImage.applyingFilter(
            "CIPixellate",
            withInputParameters: [
                kCIInputScaleKey: inputScale,
                kCIInputCenterKey: inputCenter
            ]
        )
    }
}

