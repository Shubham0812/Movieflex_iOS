//
//  Profile.swift
//  Minimal To-Do
//
//  Created by Shubham Singh on 14/08/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

@IBDesignable class Profile: UIView {
    @IBOutlet weak var profileImageView: UIImageView!
    
    var cornerRadius: CGFloat = 24 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var profileImage: UIImage = UIImage() {
        didSet {
            self.profileImageView.image = profileImage
        }
    }
    
    // MARK:- Initializers for the viewController
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        setupView()
    }
    
    // MARK:- functions for the viewController
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = UIColor.secondaryLabel.cgColor
        self.layer.borderWidth = 4
        
        self.profileImageView.layer.cornerRadius = cornerRadius
        self.profileImageView.image = profileImage
    }
}
