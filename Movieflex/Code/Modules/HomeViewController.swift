//
//  ViewController.swift
//  Movieflex
//
//  Created by Shubham Singh on 15/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK:- outlets for the viewController
    
    // MARK:- variables for the viewController

    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.fetchMovies(query: "batman")
    }
    
    // MARK:- objc & outlet functions for the viewController

    // MARK:- functions for the viewController
    func fetchMovies(query: String) {
        NetworkManager.shared.getTitlesAutocomplete(query: query) { (movies, error) in

        }
        
        NetworkManager.shared.getTitlesMetaData(titleIds: ["tt4154756", "tt0068646"]) { _,_
            in
        }
    }
    
    // MARK:- utility functions for the viewController



}

