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
    @IBOutlet weak var searchTableView: UITableView!
    
    // MARK:- variables for the viewController
    var searchViewModel: MovieSearchViewModel!
    
    // MARK:- lifeCycle for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(MovieSearchViewCell().asNib(), forCellReuseIdentifier: MovieSearchViewCell.description())
        
        self.searchViewModel = MovieSearchViewModel(handler: FileHandler(), networkManager: NetworkManager(), defaultsManager: UserDefaultsManager())
        
        self.searchViewModel.searchedTitles.bind { _ in
            self.searchTableView.reloadData()
        }
        
        self.customizeUI()
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchViewModel.getTitlesFromSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
    }
    
    // MARK:- utility functions for the viewController
    func customizeUI() {
        
    }
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let movieViewModels = self.searchViewModel.searchedTitles.value else { return 0}
        return movieViewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieSearchViewCell().rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MovieSearchViewCell.description()) as? MovieSearchViewCell {
            guard let movieViewModels = self.searchViewModel.searchedTitles.value else { return UITableViewCell()}
            cell.searchViewModel = searchViewModel
            cell.setupCell(viewModel: movieViewModels[indexPath.row])
            return cell
        }
        fatalError()
    }
}
