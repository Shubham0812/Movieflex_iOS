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
    @IBOutlet weak var userImage: Profile!
    @IBOutlet weak var popularTitlesCollectionView: UICollectionView!
    
    
    // MARK:- variables for the viewController
    var movieListViewModel: MovieListViewModel!
    
    var movieViewModel: [MovieViewModel] = [MovieViewModel]() {
        didSet {
            self.popularTitlesCollectionView.reloadData()
        }
    }
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // popularTitles
        self.popularTitlesCollectionView.delegate = self
        self.popularTitlesCollectionView.dataSource = self
        self.popularTitlesCollectionView.register(LargeTitleCollectionViewCell().asNib(), forCellWithReuseIdentifier: LargeTitleCollectionViewCell.description())
        
        self.movieListViewModel = MovieListViewModel(defaultsManager: UserDefaultsManager(), networkManager: NetworkManager())
        
        self.movieListViewModel.popularMovies.bind { [unowned self] in 
            print("Movies", $0)
            guard let movieViewModels = $0 else { return }
            self.movieViewModel = movieViewModels
        }
    }
    
    // MARK:- objc & outlet functions for the viewController
    
    // MARK:- functions for the viewController
    
    // MARK:- utility functions for the viewController
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeTitleCollectionViewCell.description(), for: indexPath) as? LargeTitleCollectionViewCell {
            cell.setupCell(viewModel: movieViewModel[indexPath.item])
            return cell
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        
        let collectionViewWidth = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let adjustedWidth = collectionViewWidth - (flowLayout.minimumLineSpacing * (columns - 1))
        let width = floor(adjustedWidth * 1.25 / columns)
        return CGSize(width: width, height: LargeTitleCollectionViewCell().cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
}

