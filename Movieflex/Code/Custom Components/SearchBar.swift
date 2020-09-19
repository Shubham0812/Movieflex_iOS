//
//  SearchBar.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class MovieSearchBar: UISearchBar {
    
    var font = UIFont()
    var color = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupBar()
    }
    
    
    func setupBar() {
        
        self.barStyle = .black
        self.color = UIColor.label
        
        isTranslucent = false
        searchBarStyle = .minimal
        
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont(name: "Raleway-Medium", size: 16.0)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.white
        
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.label
        self.setPositionAdjustment(UIOffset(horizontal: 6, vertical: 0), for: .search)
        self.searchTextPositionAdjustment = UIOffset(horizontal: 12, vertical: 0)
        
        let searchBarStyle = self.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        
        
        let image = UIImage.backgroundImageWithColor(color: UIColor.secondaryLabel.withAlphaComponent(1), size: CGSize(width: self.frame.width, height: self.frame.height), cornerRadius: 20)
        self.setSearchFieldBackgroundImage(image, for: .normal)
        self.showsCancelButton = true
    }
}
