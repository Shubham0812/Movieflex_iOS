//
//  CoreGraphicsExtension.swift
//  Movieflex
//
//  Created by Shubham Singh on 18/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

extension CALayer {
    
    func removeLayerIfExists(_ view: UIView) {
        if let lastLayer = view.layer.sublayers?.last {
            let isPresent = lastLayer is ShimmerLayer
            if isPresent {
                self.removeFromSuperlayer()
            }
        }
    }
}
