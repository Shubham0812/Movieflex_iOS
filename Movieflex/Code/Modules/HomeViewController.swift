//
//  ViewController.swift
//  Movieflex
//
//  Created by Shubham Singh on 15/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

// If the API Response is 429 or just doesn't work -> Create a new token with your credentials here -https://rapidapi.com/apidojo/api/imdb8/ . Replace the apiKey and the APIs will work again
class HomeViewController: UIViewController {
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var userImage: Profile!
    
    @IBOutlet weak var comingSoonMoviesCollectionView: UICollectionView!
    @IBOutlet weak var popularTitlesCollectionView: UICollectionView!
    @IBOutlet weak var favoriteMoviesCollectionView: UICollectionView!
    @IBOutlet weak var favoriteActorsCollectionView: UICollectionView!
    
    @IBOutlet weak var favoriteStackView: UIStackView!
    @IBOutlet weak var favoriteActorStackView: UIStackView!
    
    // MARK:- variables for the viewController
    override class func description() -> String {
        "HomeViewController"
    }
    
    var movieListViewModel: MovieListViewModel!
    var searchViewModel: MovieSearchViewModel!
    var actorListViewModel: ActorListViewModel!
    
    let defaultsManager = UserDefaultsManager()
    let networkManager = NetworkManager()
    let fileHandler = FileHandler()
    
    var favoriteActorStackHeight: CGFloat = 0
    var favoriteMoviesStackHeight: CGFloat = 0
    var actorsStackMoved: Bool = false
    
    var visiblePaths: [IndexPath] = [IndexPath]()
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // popularTitles
        self.setCollectionView(for: popularTitlesCollectionView, with: TitleCollectionViewCell().asNib(), and: TitleCollectionViewCell.description())
        // comingSoon
        self.setCollectionView(for: comingSoonMoviesCollectionView, with: LargeTitleCollectionViewCell().asNib(), and: LargeTitleCollectionViewCell.description())
        // favorite movies
        self.setCollectionView(for: favoriteMoviesCollectionView, with: TitleCollectionViewCell().asNib(), and: TitleCollectionViewCell.description())
        // favorite movies
        self.setCollectionView(for: favoriteActorsCollectionView, with: ActorCollectionViewCell().asNib(), and: ActorCollectionViewCell.description())
        
        self.favoriteMoviesStackHeight = self.favoriteStackView.frame.height
        
        self.movieListViewModel = MovieListViewModel(defaultsManager: defaultsManager, networkManager: networkManager, handler: fileHandler)
        self.searchViewModel = MovieSearchViewModel(handler: fileHandler, networkManager: networkManager, defaultsManager: defaultsManager)
        self.actorListViewModel = ActorListViewModel(handler: fileHandler, networkManager: networkManager, defaultsManager: defaultsManager)
        
        /// bindings from the viewModels to update the View
        self.movieListViewModel.popularMovies.bind { _ in
            self.popularTitlesCollectionView.reloadData()
            self.visiblePaths.removeAll()
        }
        
        self.movieListViewModel.comingSoonMovies.bind { _ in
            self.comingSoonMoviesCollectionView.reloadData()
            self.visiblePaths.removeAll()
        }
        
        self.movieListViewModel.favoriteMovies.bind { movies in
            if let movies = movies {
                if (movies.isEmpty) {
                    self.favoriteStackView.isHidden = true
                } else {
                    if (self.actorsStackMoved) {
                        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                            self.favoriteActorStackView.frame.origin.y += self.favoriteMoviesStackHeight
                        })
                        self.actorsStackMoved = false
                    }
                    self.favoriteStackView.isHidden = false
                    self.favoriteMoviesCollectionView.reloadData()
                }
            }
        }
        
        self.movieListViewModel.noData.bind {
            guard let noDataType = $0 else { return }
            if (noDataType == .favoriteMovies) {
                self.favoriteStackView.isHidden = true
                if (!self.actorsStackMoved) {
                    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                        self.favoriteActorStackView.frame.origin.y -= self.favoriteMoviesStackHeight
                    })
                    self.actorsStackMoved = true
                }
            }
        }
        
        self.actorListViewModel.noData.bind {
            guard let noData = $0 else { return }
            if (noData == .favoriteActors) {
                self.favoriteActorStackView.isHidden = true
            } else {
                self.favoriteActorStackView.isHidden = false
            }
        }
        
        self.actorListViewModel.favoriteActors.bind { _ in 
            self.favoriteActorsCollectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.movieListViewModel.getFavorites()
        self.actorListViewModel.getFavoriteActors()
    }
    
    // MARK:- functions for the viewController
    func setCollectionView(for collectionView: UICollectionView, with nib: UINib, and identifier: String) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

/// I've used four collections in this view.
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == popularTitlesCollectionView) {
            return self.movieListViewModel.getCountForDisplay(type: .popularMovies)
        } else if (collectionView ==  favoriteMoviesCollectionView) {
            return self.movieListViewModel.getCountForDisplay(type: .favoriteMovies)
        } else if (collectionView == comingSoonMoviesCollectionView) {
            return self.movieListViewModel.getCountForDisplay(type: .comingSoonMovies)
        } else {
            return self.actorListViewModel.getCountForDisplay(type: ActorListViewModel.ListType.favoriteActors)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return UICollectionViewCell() }
            return movieListViewModel.prepareCellForDisplay(collectionView: collectionView, type: .popularMovies, indexPath: indexPath, movieViewModel: movieViewModels[indexPath.item])
            
        } else if (collectionView == favoriteMoviesCollectionView) {
            guard let movieViewModels =  movieListViewModel.favoriteMovies.value else { return UICollectionViewCell() }
            return movieListViewModel.prepareCellForDisplay(collectionView: collectionView, type: .favoriteMovies, indexPath: indexPath, movieViewModel: movieViewModels[indexPath.item])
            
        } else if (collectionView == comingSoonMoviesCollectionView) {
            guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return UICollectionViewCell() }
            return movieListViewModel.prepareCellForDisplay(collectionView: collectionView, type: .comingSoonMovies, indexPath: indexPath, movieViewModel: movieViewModels[indexPath.item])
        } else {
            guard let actorViewModels =  actorListViewModel.favoriteActors.value else { return UICollectionViewCell() }
            return self.actorListViewModel.prepareCellForDisplay(collectionView: collectionView, indexPath: indexPath, actorViewModel: actorViewModels[indexPath.item], withFavorite: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView == popularTitlesCollectionView) {
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return }
            if (indexPath.item == movieViewModels.count - 2) {
                self.movieListViewModel.getMoreTitles(type: .popularMovies)
            }
        } else if (collectionView == comingSoonMoviesCollectionView) {
            guard let movieViewModels = movieListViewModel.comingSoonMovies.value else { return }
            if (indexPath.item == movieViewModels.count - 2) {
                self.movieListViewModel.getMoreTitles(type: .comingSoonMovies)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == popularTitlesCollectionView || collectionView == favoriteMoviesCollectionView) {
            return collectionView.getSizeForHorizontalCollectionView(columns: 2.4, height: TitleCollectionViewCell().cellHeight)
        } else if (collectionView == comingSoonMoviesCollectionView) {
            return collectionView.getSizeForHorizontalCollectionView(columns: 1, height: LargeTitleCollectionViewCell().cellHeight)
        } else {
            return collectionView.getSizeForHorizontalCollectionView(columns: 2.5, height: ActorCollectionViewCell().displayCellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if (collectionView == favoriteActorsCollectionView) {
            guard let actorViewModels = actorListViewModel.favoriteActors.value else { return nil }
            let actorViewModel = actorViewModels[indexPath.item]
            
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] action in
                let delete = UIAction(title: "Remove", image: UIImage(systemName: "trash.fill"), identifier: nil) { action in
                    self.actorListViewModel.actorRemoved(for: actorViewModel)
                }
                return UIMenu(title: "", image: nil, identifier: nil, children: [delete])
            }
            return configuration
        }
        var collectionType: MovieListViewModel.ListType = .comingSoonMovies
        var movieModel = MovieViewModel(meta: nil)
        if (collectionView == popularTitlesCollectionView) {
            collectionType = .popularMovies
            guard let movieViewModels =  movieListViewModel.popularMovies.value else { return nil}
            movieModel = movieViewModels[indexPath.item]
        } else if (collectionView == comingSoonMoviesCollectionView) {
            guard let movieViewModels =  movieListViewModel.comingSoonMovies.value else { return nil}
            movieModel = movieViewModels[indexPath.item]
        } else if (collectionView == favoriteMoviesCollectionView) {
            guard let movieViewModels =  movieListViewModel.favoriteMovies.value else { return nil}
            movieModel = movieViewModels[indexPath.item]
            collectionType = .favoriteMovies
        }
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] action in
            let delete = UIAction(title: collectionType.getOptionName, image: UIImage(systemName: collectionType.symbol), identifier: nil) { action in
                self.movieListViewModel.titleRemoved(for: movieModel, type: collectionType)
            }
            return UIMenu(title: "", image: nil, identifier: nil, children: [delete])
        }
        return configuration
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
        movieDetailVC.movieListViewModel = self.movieListViewModel
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}
