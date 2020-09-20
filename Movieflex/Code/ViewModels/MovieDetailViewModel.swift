//
//  MovieDetailViewModel.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct MovieDetailViewModel {
    
    let fileHandler: FileHandler
    let networkManager: NetworkManager
    let movieId: String
    
    var movieDetails: BoxBind<TitleDetail?> = BoxBind(nil)
    
    
    // MARK:- initializer for the viewModel
    init(movieId: String, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        
        self.movieId = movieId
        self.fileHandler = handler
        self.networkManager = networkManager
        
        self.getTitleDetails()
        self.getCast()
    }
    
    // MARK:- functions for the viewModel
    func getTitleDetails() {
        networkManager.getTitleDetails(titleId: movieId) { res, error in
            guard let titleData = res else { return }
            self.movieDetails.value = titleData
        }
    }
    
    func getCast() {
        networkManager.getCastForTitle(titleId: movieId) { res, error in
            guard let casts = res else { return }
            
        }
    }
    
}
