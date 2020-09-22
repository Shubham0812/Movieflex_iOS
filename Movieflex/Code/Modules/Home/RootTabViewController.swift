//
//  RootTabViewController.swift
//  Movieflex
//
//  Created by Shubham Singh on 20/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

/// The rootTabViewController
/// It currently has two tabs, feel free to create some exciting features and tell me about it :D

class RootTabViewController: UITabBarController {

    // MARK:- variables for the viewController
    override class func description() -> String {
        "RootTabViewController"
    }
    
    // MARK:- lifeCycle for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.selectedIndex = 0
    }
    
    // MARK:- functions for the viewController
    func setupTabs() {
        self.tabBar.tintColor = UIColor.label
        self.tabBar.barStyle = .default
        
        guard let homeViewController = storyboard?.instantiateViewController(withIdentifier: HomeViewController.description()) else { return }
        let searchViewController =  UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: MovieSearchViewController.description())
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home" , image: UIImage(systemName: "house")?.withRenderingMode(.automatic), selectedImage: UIImage(systemName: "house.fill")?.withRenderingMode(.automatic))
        homeViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        homeViewController.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 2.0)
        
        searchViewController.tabBarItem = UITabBarItem(title: "Search" , image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.automatic), selectedImage: UIImage(named: "magnifyingglass")?.withRenderingMode(.automatic))
        searchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        searchViewController.tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: 2.0)
        viewControllers = [homeViewController, searchViewController]
    }
}

