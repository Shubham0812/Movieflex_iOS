//
//  MovieDetailViewModel.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct MovieDetailViewModel {
    
    // MARK:- variable for the viewModel
    let fileHandler: FileHandler
    let networkManager: NetworkManager
    let defaultsManager: UserDefaultsManager

    let movieId: String
    
    var movieReleaseDate: BoxBind<String?> = BoxBind(nil)
    var moviePlot:  BoxBind<String?> = BoxBind(nil)
    
    // MARK:- initializer for the viewModel
    init(movieId: String, handler: FileHandler, networkManager: NetworkManager, defaultsManager: UserDefaultsManager) {
        self.movieId = movieId
        self.fileHandler = handler
        self.networkManager = networkManager
        self.defaultsManager = defaultsManager
        
        self.getTitleDetails()
    }
    
    // MARK:- functions for the viewModel
    func getTitleDetails() {
        networkManager.getTitleDetails(titleId: movieId) { res, error in
            guard let titleDetails = res else { return }
            self.movieReleaseDate.value = titleDetails.releaseDate
            if let titlePlotText = titleDetails.plotOutline?.text {
                 self.moviePlot.value = titlePlotText
            } else {
                self.moviePlot.value = "The plot is unknown at this time. We'll be updating shortly."
            }
        }
    }
}

extension MovieDetailViewModel: Likeable {
    var favoriteType: Favorites  {
        .favoriteMovies
    }
    func likePressed(id: String) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(id: id, type: favoriteType)
        if (buttonStatus) {
            return true
        } else {
            return false
        }
    }
    
    func checkIfFavorite(id: String) -> Bool {
        if (defaultsManager.checkIfFavorite(id: id, type: favoriteType)) {
            return true
        } else  {
            return false
        }
    }
}
