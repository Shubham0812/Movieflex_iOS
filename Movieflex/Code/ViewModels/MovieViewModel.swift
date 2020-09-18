//
//  MovieViewModel.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct MovieViewModel {
    
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
        formatter.dateFormat = "DD MMM yy"
        return formatter
    }()
    
    var moviePosterUrl: URL {
        guard let url = URL(string: titleInfo.image.url) else { return URL(string: "")! }
        return url
    }
    
    var moviePosterImage: BoxBind<UIImage?> = BoxBind(nil)
    
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
    
    init(meta: TitleMetaData?, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        guard let meta = meta else {
            
            self.titleInfo = TitleInfo(runningTimeInMinutes: nil, title: "", titleType: "", year: 0, image: TitleInfo.TitlePoster(height: 0, width: 0, url: ""))
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
        if (fileHandler.checkIfFileExists(titleId: id)) {
            self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(titleId: id).path)
        } else {
            networkManager.downloadMoviePoster(url: self.moviePosterUrl, titleId: self.id) { res, error in
                if (error == .none) {
                    self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(titleId: id).path)
                }
            }
        }
    }
    
}


struct MovieListViewModel {
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    let fileHandler: FileHandler
    
    var offset: Int = 0
    var limit: Int = 10
    
    var popularMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    var comingSoonMovies: BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    
    var fetchingData: BoxBind<(Bool, Int)> = BoxBind((false, 10))
    
    
    // MARK:- initializers for the viewModel
    init(defaultsManager: UserDefaultsManager, networkManager: NetworkManager, handler: FileHandler) {
        self.defaultsManager = defaultsManager 
        self.networkManager = networkManager
        self.fileHandler = handler
        
        self.fetchingData.value = (true, limit)
        self.getPopularMovieTitles(offset: offset, limit: limit)
        self.getComingSoonTitles(offset: offset, limit: limit)
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
        let moviesList = defaultsManager.getComingSoonTitlesList()
        if (moviesList.isEmpty) {
        } else {
            let titleIds = moviesList[offset..<limit]
            networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
                guard let titlesMetaData = res else { return }
                self.comingSoonMovies.value = titlesMetaData.map { MovieViewModel(meta: $0)}
            }
        }
    }
}

extension MovieListViewModel {
    
    func getMoreTitles() {
        print("Get moreeee")
    }
}


