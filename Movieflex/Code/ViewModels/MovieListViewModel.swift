//
//  MovieListViewModel.swift
//  Movieflex
//
//  Created by Shubham Singh on 21/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

/// The ListViewModels are the ones that calls the APIs and provide the array data to the Viewcontrollers.
/// There are three array of MovieViewModels here, denoted by the enum below.˘
struct MovieListViewModel {
    enum ListType {
        case popularMovies
        case comingSoonMovies
        case favoriteMovies
        
        var getOptionName: String {
            switch self {
            case .popularMovies, .comingSoonMovies:
                return "Not Interested"
            case .favoriteMovies:
                return "Remove"
            }
        }
        
        var symbol: String {
            switch self {
            case .popularMovies, .comingSoonMovies:
                return "slash.circle.fill"
            case .favoriteMovies:
                return "trash.fill"
            }
        }
    }
    
    // MARK:- variables for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    let fileHandler: FileHandler
    let favoriteType: Favorites = .favoriteMovies
    
    var popularMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    var comingSoonMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    var favoriteMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    
    var popularMoviesOffset: BoxBind<(Int, Int)> = BoxBind((0, 10))
    var comingSoonMoviesOffset: BoxBind<(Int, Int)> = BoxBind((0, 10))
    
    var noData: BoxBind<(ListType?)> = BoxBind(nil)
    var updateCollection: BoxBind<(ListType, IndexPath)?> = BoxBind(nil)
    
    // MARK:- initializer for the viewModel
    init(defaultsManager: UserDefaultsManager, networkManager: NetworkManager, handler: FileHandler) {
        self.defaultsManager = defaultsManager
        self.networkManager = networkManager
        self.fileHandler = handler
        
        /// Getting 10 popularTitles and ComingSoonTitles from the API
        let (offset,limit) = self.popularMoviesOffset.value
        self.getPopularMovieTitles(offset: offset, limit: limit)
        self.getComingSoonTitles(offset: offset, limit: limit)
    }
    
    // MARK:- functions for the viewModel
    func getPopularMovieTitles(offset: Int, limit: Int) {
        let moviesList = defaultsManager.getPopularTitlesList()
        if (moviesList.isEmpty) {
            // Fetch and store the titleIds if the app is run for the first time
            fetchTitlesIfFavoritesNotSet(offset: offset, limit: limit, type: .popularMovies)
        } else {
            let titleIds = moviesList[offset..<limit]
            self.fetchAndStoreTitles(titleIds: Array(titleIds), type: .popularMovies)
        }
    }
    
    func getComingSoonTitles(offset: Int, limit: Int) {
        let moviesList = defaultsManager.getComingSoonTitlesList()
        if (moviesList.isEmpty) {
            // Fetch and store the titleIds if the app is run for the first time
            fetchTitlesIfFavoritesNotSet(offset: offset, limit: limit, type: .comingSoonMovies)
        } else {
            let titleIds = moviesList[offset..<limit]
            self.fetchAndStoreTitles(titleIds: Array(titleIds), type: .comingSoonMovies)
        }
    }
    
    func fetchTitlesIfFavoritesNotSet(offset: Int, limit: Int, type: ListType) {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { fetchTimer in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                var moviesList: [String] = [String]()
                if (type == .comingSoonMovies) {
                    moviesList = defaultsManager.getComingSoonTitlesList()
                } else if (type == .popularMovies) {
                    moviesList = defaultsManager.getPopularTitlesList()
                }
                if (!moviesList.isEmpty) {
                    let titleIds = moviesList[offset..<limit]
                    self.fetchAndStoreTitles(titleIds: Array(titleIds), type: type)
                    fetchTimer.invalidate()
                }
            }
        }
    }
    
    func fetchAndStoreTitles(titleIds: [String], type: ListType) {
        networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
            guard let titlesMetaData = res else { return }
            if (type == .comingSoonMovies) {
                self.comingSoonMovies.value = titlesMetaData.map { MovieViewModel(meta: $0) }
            } else if (type == .popularMovies) {
                self.popularMovies.value = titlesMetaData.map { MovieViewModel(meta: $0)}
            }
        }
    }
    
    func getFavorites() {
        let favorties = defaultsManager.getFavorites(type: favoriteType)
        if (favorties.isEmpty) {
            self.noData.value = .favoriteMovies
        } else {
            self.noData.value = .none
            // If there's no change don't call the API
            if let favoritesArray = self.favoriteMovies.value {
                if (favoritesArray.count == favorties.count) {
                    return
                } else {
                    networkManager.getTitlesMetaData(titleIds: Array(favorties)) { res, error in
                        guard let titlesMetaData = res else { return }
                        self.favoriteMovies.value = titlesMetaData.map { MovieViewModel(meta: $0)}.sorted { $0.id < $1.id}
                    }
                }
            }
        }
    }
}


/// Methods for fetching data, used by the viewControllers
extension MovieListViewModel {
    func getMoreTitles(type: ListType) {
        if (type == .comingSoonMovies) {
            addComingSoonTitles(by: 8)
        } else if (type == .popularMovies) {
            addPopularTitles(by: 8)
        }
    }
    
    func titleRemoved(for model: MovieViewModel, type: ListType) {
        if (type == .favoriteMovies) {
            self.defaultsManager.removeFromFavorites(id: model.id, favorites: defaultsManager.getFavorites(type: favoriteType), type: favoriteType)
            guard var viewModels = self.favoriteMovies.value else { return }
            filterModels(viewModels: &viewModels, filterId: model.id)
            if (viewModels.count == 0) {
                self.noData.value = .favoriteMovies
            }
            self.favoriteMovies.value = viewModels
        } else if (type == .comingSoonMovies) {
            guard var viewModels = self.comingSoonMovies.value else { return }
            filterModels(viewModels: &viewModels, filterId: model.id)
            if (viewModels.count == 0) {
                self.noData.value = .comingSoonMovies
            }
            self.comingSoonMovies.value = viewModels
            addComingSoonTitles(by: 1)
        } else {
            guard var viewModels = self.popularMovies.value else { return }
            filterModels(viewModels: &viewModels, filterId: model.id)
            if (viewModels.count == 0) {
                self.noData.value = .popularMovies
            }
            self.popularMovies.value = viewModels
            addPopularTitles(by: 1)
        }
    }
    
    func filterModels(viewModels: inout [MovieViewModel], filterId: String ) {
        viewModels = viewModels.filter( {
            $0.id != filterId
        })
    }
    
    func addPopularTitles(by count: Int) {
        var (offset, limit) = self.popularMoviesOffset.value
        offset = limit
        limit = limit + count
        self.popularMoviesOffset.value = (offset,limit)
        let moviesList = defaultsManager.getPopularTitlesList()
        let titleIds = moviesList[offset..<limit]
        DispatchQueue.global().async {
            networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
                guard let titlesMetaData = res, var viewModels = self.popularMovies.value else { return }
                viewModels.append(contentsOf: titlesMetaData.map { MovieViewModel(meta: $0) })
                self.popularMovies.value = viewModels
            }
        }
    }
    
    func addComingSoonTitles(by count: Int) {
        var (offset, limit) = self.comingSoonMoviesOffset.value
        offset = limit
        limit = limit + count
        self.comingSoonMoviesOffset.value = (offset,limit)
        let moviesList = defaultsManager.getComingSoonTitlesList()
        let titleIds = moviesList[offset..<limit]
        DispatchQueue.global().async {
            networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
                guard let titlesMetaData = res, var viewModels = self.comingSoonMovies.value else { return }
                viewModels.append(contentsOf: titlesMetaData.map { MovieViewModel(meta: $0) })
                self.comingSoonMovies.value = viewModels
            }
        }
    }
    
    /// methods for displaying cell data
    func getCountForDisplay(type: ListType) -> Int {
        if (type == .comingSoonMovies) {
            guard let movieViewModels =  self.comingSoonMovies.value else { return 0 }
            return movieViewModels.count
        } else if (type == .favoriteMovies) {
            guard let movieViewModels = self.favoriteMovies.value else { return 0 }
            return movieViewModels.count
        } else {
            guard let movieViewModels =  self.popularMovies.value else { return 0 }
            return movieViewModels.count
        }
    }
    
    func prepareCellForDisplay(collectionView: UICollectionView, type: ListType, indexPath: IndexPath, movieViewModel: MovieViewModel) -> UICollectionViewCell {
        
        if (type == .popularMovies || type == .favoriteMovies) {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.description(), for: indexPath) as? TitleCollectionViewCell {
                cell.setupCell(viewModel: movieViewModel)
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeTitleCollectionViewCell.description(), for: indexPath) as? LargeTitleCollectionViewCell {
                cell.setupCell(viewModel: movieViewModel)
                return cell
            }
        }
        fatalError()
    }
}


