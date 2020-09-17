//
//  MovieViewModel.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct MovieViewModel {
    
    let movieTitle: TitleInfo
    let id: String
    let rating: TitleRating
    let releaseDate: String
    let certificate: String
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
    
    init(meta: TitleMetaData) {
        self.movieTitle = meta.title
        self.id = meta.titleId
        self.rating = meta.ratings
        self.certificate = meta.certificate
        self.genres = meta.genres
        
        if let date = dateFormatter.date(from: meta.releaseDate) {
            self.releaseDate = readableFormatter.string(from: date)
        } else {
            self.releaseDate = ""
        }
    }
}


