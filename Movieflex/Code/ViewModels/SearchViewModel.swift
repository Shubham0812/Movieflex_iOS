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
    let defaultsManager: UserDefaultsManager
    
//    var searchedTitles:  BoxBind<[MovieViewModel]?> = BoxBind(nil)
    var searchedTitles:  BoxBind<[MovieViewModel]?> = BoxBind([MovieViewModel](repeating: MovieViewModel(meta: nil), count: 10))
    var debounceTimer: BoxBind<Timer?> = BoxBind(nil)
    
    init(handler:FileHandler, networkManager: NetworkManager, defaultsManager: UserDefaultsManager) {
        self.fileHandler = handler
        self.networkManager = networkManager
        self.defaultsManager = defaultsManager
    }
    
    func getTitlesFromSearch(query: String) {
        debounceTimer.value?.invalidate()
        debounceTimer.value =  Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            print("query", query)
            self.searchedTitles.value = [MovieViewModel](repeating: MovieViewModel(meta: nil), count: 5)
            self.networkManager.getTitlesFromSearch(query: query) { res, error in
                guard let titleIds = res else {
                    print(error as Any)
                    self.searchedTitles.value = nil
                    return
                }
                networkManager.getTitlesMetaData(titleIds: titleIds) { res, error in
                    guard let titlesMetaData = res else {
                        self.searchedTitles.value = nil
                        return
                    }
                    self.searchedTitles.value = titlesMetaData.map { MovieViewModel(meta: $0)}
                }
            }
        }
    }
    
    func checkIfFavorite(titleId: String) -> Bool {
        if (defaultsManager.checkIfFavorite(id: titleId, type: .favoriteMovies)) {
            return true
        } else  {
            return false
        }
    }
}

extension MovieSearchViewModel {
    func likePressed(titleId: String) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(id: titleId, type: .favoriteMovies)
        if (buttonStatus) {
            return true
        } else {
            return false
        }
    }
}
