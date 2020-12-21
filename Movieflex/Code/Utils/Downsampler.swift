//
//  ImageDownsampler.swift
//  Movieflex
//
//  Created by Shubham on 18/12/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct Downsampler {
    // MARK:- functions
    static func downsampleImage(imageURL: URL, frameSize: CGSize,
                                scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        
        /// creates an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        /// downsample the image
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(frameSize.width, frameSize.height) * scale
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0,
                                                                         downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}
