//
//  Profile.swift
//  Movieflex
//
//  Created by Shubham Singh on 15/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

@IBDesignable class Profile: UIView {
    
    // MARK:- outlets for the view
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK:- variables for the view
    @IBInspectable var cornerRadius: CGFloat = 24 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderAlpha: CGFloat = 1.0 {
        didSet {
            self.layer.borderColor = borderColor.withAlphaComponent(borderAlpha).cgColor
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.secondaryLabel {
        didSet {
            self.layer.borderColor = borderColor.withAlphaComponent(borderAlpha).cgColor
        }
    }
    
    @IBInspectable var profileImage: UIImage = UIImage() {
        didSet {
            self.profileImageView.image = profileImage
        }
    }
    
    
    // MARK:- Initializers for the view
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
        self.layer.borderColor = borderColor.withAlphaComponent(borderAlpha).cgColor
        self.layer.borderWidth = 2
        
        self.profileImageView.layer.cornerRadius = cornerRadius
        self.profileImageView.image = profileImage
    }
}
