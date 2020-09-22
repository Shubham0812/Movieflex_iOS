//
//  LineView.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

@IBDesignable class LineView: UIView {
    
    // MARK:- variables for the view
    @IBInspectable var cornerRadius: CGFloat = 4 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    var background: UIColor = UIColor.tertiaryLabel {
        didSet {
            self.backgroundColor = background
        }
    }
    
    // MARK:- Initializers for the view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
         setupView()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK:- functions for the viewController
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = background
    }
}

