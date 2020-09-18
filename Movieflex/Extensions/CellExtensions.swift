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

extension UICollectionReusableView {
    func aNib() -> UINib {
        return UINib(nibName: Self.description(), bundle: nil)
    }
}
