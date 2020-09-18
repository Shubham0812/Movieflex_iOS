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
    
    
    @IBOutlet weak var comingSoonMoviesCollectionView: UICollectionView!
    @IBOutlet weak var popularTitlesCollectionView: UICollectionView!
    
    
    // MARK:- variables for the viewController
    var movieListViewModel: MovieListViewModel!
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // popularTitles
        self.popularTitlesCollectionView.delegate = self
        self.popularTitlesCollectionView.dataSource = self
        self.popularTitlesCollectionView.register(LargeTitleCollectionViewCell().asNib(), forCellWithReuseIdentifier: LargeTitleCollectionViewCell.description())
        
        // comingSoon
        self.comingSoonMoviesCollectionView.delegate = self
        self.comingSoonMoviesCollectionView.dataSource = self
        self.comingSoonMoviesCollectionView.register(TitleCollectionViewCell().asNib(), forCellWithReuseIdentifier: TitleCollectionViewCell.description())
        
        
        self.movieListViewModel = MovieListViewModel(defaultsManager: UserDefaultsManager(), networkManager: NetworkManager(), handler: FileHandler())
        
        self.movieListViewModel.popularMovies.bind { _ in
            self.popularTitlesCollectionView.reloadData()
        }
        
        self.movieListViewModel.comingSoonMovies.bind { _ in
            self.comingSoonMoviesCollectionView.reloadData()
        }
        
        self.movieListViewModel.fetchingData.bind { [unowned self] in
            print($0, $1)
            
        }
    }
    
    // MARK:- objc & outlet functions for the viewController
    
    // MARK:- functions for the viewController
    
    // MARK:- utility functions for the viewController
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return 0 }
            return movieViewModels.count
        } else {
            guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return 0 }
            return movieViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return UICollectionViewCell() }
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeTitleCollectionViewCell.description(), for: indexPath) as? LargeTitleCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.item])
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.description(), for: indexPath) as? TitleCollectionViewCell {
                guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return UICollectionViewCell() }
                cell.setupCell(viewModel: movieViewModels[indexPath.item])
                return cell
            }
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { fatalError() }
            if (indexPath.item == movieViewModels.count - 1) {
                self.movieListViewModel.getMoreTitles()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == popularTitlesCollectionView) {
            let columns: CGFloat = 3
            
            let collectionViewWidth = collectionView.bounds.width
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let adjustedWidth = collectionViewWidth - (flowLayout.minimumLineSpacing * (columns - 1))
            let width = floor(adjustedWidth * 1.25 / columns)
            return CGSize(width: width, height: LargeTitleCollectionViewCell().cellHeight)
        } else {
            let columns: CGFloat = 1
            
            let collectionViewWidth = collectionView.bounds.width
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let adjustedWidth = collectionViewWidth - (flowLayout.minimumLineSpacing * (columns - 1))
            var width = floor(adjustedWidth * 0.95 / columns)
            width = min(width, 450)
            
            return CGSize(width: width, height: LargeTitleCollectionViewCell().cellHeight)
        }
    }
}

