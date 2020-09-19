//
//  SearchViewModel.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit


struct MovieSearchViewModel {
    
    let fileHandler: FileHandler
    let networkManager: NetworkManager

    let id: String
    let movieName: String
    let movieType: String
    let rank: Int
    let stars: [String]
    let year: String
    let poster: TitlePoster
    
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
        guard let url = URL(string: poster.url) else { return URL(string: "")! }
        return url
    }
    
    var moviePosterImage: BoxBind<UIImage?> = BoxBind(nil)
    
    
    init(title: AutoCompleteTitle, handler: FileHandler, networkManager: NetworkManager) {
        self.id = title.id
        self.movieName = title.name
        self.rank = title.rank
        self.stars = title.starring.components(separatedBy: ",")
        
        if let movieType = title.type {
            self.movieType = movieType
        } else {
            self.movieType = ""
        }
        
        if let year = title.year {
            self.year = "\(year)"
        } else {
            self.year = ""
        }
        
        self.poster = title.poster
        self.fileHandler = handler
        self.networkManager = networkManager
    }
}
