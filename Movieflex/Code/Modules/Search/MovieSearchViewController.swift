//
//  MovieSearchViewController.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//


import UIKit



class MovieSearchViewController: UIViewController, UISearchBarDelegate {
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK:- variables for the viewController
//    let 
    var debounceTimer: Timer = Timer()

    // MARK:- lifeCycle for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.delegate = self
        
        let textFieldInsideUISearchBarLabel = searchBar!.value(forKey: "placeholder") as? UILabel
    textFieldInsideUISearchBarLabel?.textColor = UIColor.red
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)

        print("search text", searchText)
        
        /// debounce test
        debounceTimer.invalidate()
         debounceTimer =  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                print("Search now", searchText)
            
            NetworkManager().getTitlesAutocomplete(query: searchText) { res, error in
                print(res)
            }

        }
        
//

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
    }
}

//extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//}
