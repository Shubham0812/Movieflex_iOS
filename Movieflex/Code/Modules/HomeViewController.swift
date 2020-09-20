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
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    
    
    // MARK:- variables for the viewController
    var movieListViewModel: MovieListViewModel!
    var searchViewModel: MovieSearchViewModel!
    
    let defaultsManager = UserDefaultsManager()
    let networkManager = NetworkManager()
    let fileHandler = FileHandler()
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // popularTitles
        self.popularTitlesCollectionView.delegate = self
        self.popularTitlesCollectionView.dataSource = self
        self.popularTitlesCollectionView.register(TitleCollectionViewCell().asNib(), forCellWithReuseIdentifier: TitleCollectionViewCell.description())
        
        // comingSoon
        self.comingSoonMoviesCollectionView.delegate = self
        self.comingSoonMoviesCollectionView.dataSource = self
        self.comingSoonMoviesCollectionView.register(LargeTitleCollectionViewCell().asNib(), forCellWithReuseIdentifier: LargeTitleCollectionViewCell.description())
        
        // favorites
        self.favoritesCollectionView.delegate = self
        self.favoritesCollectionView.dataSource = self
        self.favoritesCollectionView.register(TitleCollectionViewCell().asNib(), forCellWithReuseIdentifier: TitleCollectionViewCell.description())
        
        self.movieListViewModel = MovieListViewModel(defaultsManager: defaultsManager, networkManager: networkManager, handler: fileHandler)
        self.searchViewModel = MovieSearchViewModel(handler: fileHandler, networkManager: networkManager, defaultsManager: defaultsManager)
        
        self.movieListViewModel.popularMovies.bind { _ in
            self.popularTitlesCollectionView.reloadData()
        }
        
        self.movieListViewModel.comingSoonMovies.bind { _ in
            self.comingSoonMoviesCollectionView.reloadData()
        }
        
        self.movieListViewModel.favoriteMovies.bind { movies in
            self.favoritesCollectionView.reloadData()
        }
       
        self.movieListViewModel.noData.bind {
            guard let noDataType = $0 else { return }
            if (noDataType == .favoriteMovies) {
                self.
            }
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
        } else if (collectionView ==  favoritesCollectionView) {
            guard let movieViewModels = movieListViewModel.favoriteMovies.value else { return 0 }
            return movieViewModels.count
        } else {
            guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return 0 }
            return movieViewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return UICollectionViewCell() }
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.description(), for: indexPath) as? TitleCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.item])
                return cell
            }
        } else if (collectionView == favoritesCollectionView) {
            guard let movieViewModels =  movieListViewModel.favoriteMovies.value else { return UICollectionViewCell() }
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.description(), for: indexPath) as? TitleCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.item])
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeTitleCollectionViewCell.description(), for: indexPath) as? LargeTitleCollectionViewCell {
                guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return UICollectionViewCell() }
                cell.setupCell(viewModel: movieViewModels[indexPath.item])
                return cell
            }
        }
        fatalError()
    }
    
    //    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        if (collectionView == popularTitlesCollectionView) {
    //            guard let movieViewModels =  movieListViewModel.popularMovies.value else { fatalError() }
    //            if (indexPath.item == movieViewModels.count - 1) {
    ////                self.movieListViewModel.getMoreTitles(type: )
    //            }
    //        }
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == popularTitlesCollectionView || collectionView == favoritesCollectionView) {
            let columns: CGFloat = 3
            
            let collectionViewWidth = collectionView.bounds.width
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let adjustedWidth = collectionViewWidth - (flowLayout.minimumLineSpacing * (columns - 1))
            let width = floor(adjustedWidth * 1.25 / columns)
            return CGSize(width: width, height: TitleCollectionViewCell().cellHeight)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if (collectionView == favoritesCollectionView) {
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] action in
                guard let movieViewModels =  movieListViewModel.favoriteMovies.value else { return nil }
                let delete = UIAction(title: "Remove", image: UIImage(systemName: "trash.fill"), identifier: nil) { action in
                    self.movieListViewModel.favoriteRemoved(for: movieViewModels[indexPath.item])
                }
                return UIMenu(title: "", image: nil, identifier: nil, children: [delete])
            }
            return configuration
        }
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var movieModel = MovieViewModel(meta: nil)
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return }
            movieModel = movieViewModels[indexPath.item]
        } else if (collectionView == comingSoonMoviesCollectionView) {
            guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return }
            movieModel = movieViewModels[indexPath.item]
        } else {
            guard let movieViewModels =  movieListViewModel.favoriteMovies.value else { return }
            movieModel = movieViewModels[indexPath.item]
        }
        guard let movieDetailVC = self.storyboard?.instantiateViewController(identifier: MovieDetailViewController.description()) as? MovieDetailViewController else { return }
        movieDetailVC.viewModel = movieModel
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

