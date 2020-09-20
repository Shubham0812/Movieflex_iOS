//
//  MovieViewModel.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct MovieViewModel {
    // MARK:- variable for the viewModel
    let fileHandler: FileHandler
    let networkManager: NetworkManager
    
    let titleInfo: TitleInfo
    let id: String
    let rating: TitleRating
    let releaseDate: String
    let genres: [String]
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-DD-MM"
        return formatter
    }()
    
    let readableFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var moviePosterUrl: URL {
        guard let url = URL(string: titleInfo.image.url) else { return URL(string: "")! }
        return url
    }
    
    var moviePosterImage: BoxBind<UIImage?> = BoxBind(nil)
    var isFavorite: BoxBind<Bool?> = BoxBind(nil)
    
    
    var movieTitle: String {
        titleInfo.title
    }
    
    var movieGenres: String {
        if (genres.count >= 2) {
            return genres[0..<2].joined(separator: ", ")
        } else {
            return genres.joined(separator: ", ")
        }
    }
    
    var movieRunTime: String {
        guard let runningTime = self.titleInfo.runningTimeInMinutes else { return "" }
        let hours = runningTime / 60
        let minutes = runningTime % 60
        if (hours > 0) {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
    
    init(meta: TitleMetaData?, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        guard let meta = meta else {
            self.titleInfo = TitleInfo(runningTimeInMinutes: nil, title: "", titleType: "", year: 0, image: TitlePoster(height: 0, width: 0, url: ""))
            self.id = ""
            self.rating = TitleRating(rating: nil, ratingCount: nil, topRank: nil, bottomRank: nil)
            self.genres = []
            self.releaseDate = ""
            self.fileHandler = handler
            self.networkManager = networkManager
            return
        }
        self.titleInfo = meta.title
        self.id = meta.titleId
        self.rating = meta.ratings
        self.genres = meta.genres
        
        if let date = dateFormatter.date(from: meta.releaseDate) {
            self.releaseDate = readableFormatter.string(from: date)
        } else {
            self.releaseDate = "N/A"
        }
        
        self.fileHandler = handler
        self.networkManager = networkManager
        
        self.getMoviePoster()
    }
    
    func getMoviePoster() {
        if (fileHandler.checkIfFileExists(id: id)) {
            self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
        } else {
            networkManager.downloadMoviePoster(url: self.moviePosterUrl, id: self.id) { res, error in
                if (error == .none) {
                    self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
                }
            }
        }
    }
}


struct MovieListViewModel {
    
    enum ListType {
        case popularMovies
        case comingSoonMovies
        case favoriteMovies
    }
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    let fileHandler: FileHandler
    let favoriteType: UserDefaultsManager.Favorites = .favoriteMovies
    
    var offset: Int = 0
    var limit: Int = 10
    
    var popularMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    var comingSoonMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    var favoriteMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    
    var noData: BoxBind<(ListType?)> = BoxBind(nil)
    
    
    // MARK:- initializers for the viewModel
    init(defaultsManager: UserDefaultsManager, networkManager: NetworkManager, handler: FileHandler) {
        self.defaultsManager = defaultsManager 
        self.networkManager = networkManager
        self.fileHandler = handler
                
        self.getPopularMovieTitles(offset: offset, limit: limit)
        self.getComingSoonTitles(offset: offset, limit: limit)
        self.getFavorites()
    }
    
    // MARK:- functions for the viewModel
    func getPopularMovieTitles(offset: Int, limit: Int) {
        let moviesList = defaultsManager.getPopularTitlesList()
        if (moviesList.isEmpty) {
        } else {
            let titleIds = moviesList[offset..<limit]
            networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
                guard let titlesMetaData = res else { return }
                self.popularMovies.value = titlesMetaData.map { MovieViewModel(meta: $0)}
            }
        }
    }
    
    func getComingSoonTitles(offset: Int, limit: Int) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let moviesList = defaultsManager.getComingSoonTitlesList()
            if (moviesList.isEmpty) {
            } else {
                let titleIds = moviesList[offset..<limit]
                networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
                    guard let titlesMetaData = res else { return }
                    self.comingSoonMovies.value = titlesMetaData.map { MovieViewModel(meta: $0) }
                }
            }
        }
    }
    
    func getFavorites() {
        let favorties = defaultsManager.getFavorites(type: favoriteType)
        if (favorties.isEmpty) {
            self.noData.value = .favoriteMovies
        } else {
            networkManager.getTitlesMetaData(titleIds: Array(favorties)) { res, error in
                guard let titlesMetaData = res else { return }
                self.favoriteMovies.value = titlesMetaData.map { MovieViewModel(meta: $0)}
            }
        }
    }
}

extension MovieListViewModel {
    
    //    func getMoreTitles(type: MovieType) {
    //        if (type == .comingSoon) {
    //            let moviesList = defaultsManager.getComingSoonTitlesList()
    //            guard let comingSoonTitles = self.comingSoonMovies.value else { return }
    //            let titleIds = moviesList[comingSoonTitles.count ..< comingSoonTitles + limit]
    //
    //            networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
    //                guard let titlesMetaData = res else { return }
    //                self.comingSoonMovies.value = self.comingSoonMovies.value + titlesMetaData.map { MovieViewModel(meta: $0)}
    //            }
    //        }
    //    }
    
    func favoriteRemoved(for model: MovieViewModel) {
        self.defaultsManager.removeFromFavorites(id: model.id, favorites: defaultsManager.getFavorites(type: favoriteType), type: favoriteType)
        guard let viewModels = self.favoriteMovies.value else { return }
        let newModels = viewModels.filter( {
            $0.id != model.id
        })
        self.favoriteMovies.value = newModels
    }
}


