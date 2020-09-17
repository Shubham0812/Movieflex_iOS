//
//  MovieViewModel.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct MovieViewModel {
    
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
    
    var movieTitle: String {
        titleInfo.title
    }
    
    var movieGenres: String {
        genres.joined(separator: ", ")
    }
    
    init(meta: TitleMetaData) {
        self.titleInfo = meta.title
        self.id = meta.titleId
        self.rating = meta.ratings
        self.genres = meta.genres
        
        if let date = dateFormatter.date(from: meta.releaseDate) {
            self.releaseDate = readableFormatter.string(from: date)
        } else {
            self.releaseDate = ""
        }
    }
}


struct MovieListViewModel {
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    
    var offset: Int = 0
    var limit: Int = 10
    
    var popularMovies: BoxBind<[MovieViewModel]?> = BoxBind(nil)
    
    // MARK:- initializers for the viewModel
    init(defaultsManager: UserDefaultsManager, networkManager: NetworkManager) {
        self.defaultsManager = defaultsManager 
        self.networkManager = networkManager
        
        self.getPopularMovieTitles(offset: offset, limit: limit)
    }
    
    // MARK:- functions for the viewModel
    func getPopularMovieTitles(offset: Int, limit: Int) {
        let moviesList = defaultsManager.getPopularTitlesList()
        let titleIds = moviesList[offset..<limit]
        networkManager.getTitlesMetaData(titleIds: Array(titleIds)) { res, error in
            guard let titlesMetaData = res else { return }
            self.popularMovies.value = titlesMetaData.map { MovieViewModel(meta: $0)}
        }
    }
}

extension MovieListViewModel {
    
}


