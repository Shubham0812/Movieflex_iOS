//
//  CellExtensions.swift
//  Movieflex
//
//  Created by Shubham Singh on 17/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func asNib() -> UINib {
        return UINib(nibName: Self.description(), bundle: nil)
    }
}

extension UITableViewCell {
    func asNib() -> UINib {
        return UINib(nibName: Self.description(), bundle: nil)
    }
}

extension UICollectionView {
    func getSizeForHorizontalCollectionView(columns: CGFloat, height: CGFloat) -> CGSize {
        let collectionViewWidth = self.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let adjustedWidth = collectionViewWidth - (flowLayout.minimumLineSpacing * (columns - 1))
        let width = floor(adjustedWidth / columns)
        return CGSize(width: width, height: height)
    }
}
