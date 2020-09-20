//
//  UserDefaultsManager.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation


class UserDefaultsManager {
    
    // MARK:- getter functions
    func getPopularTitlesList() -> [String] {
        guard let titles = UserDefaults.standard.array(forKey: "popularTitles") as? [String]  else { return [] }
        return titles
    }
    
    func getComingSoonTitlesList() -> [String] {
        guard let titles = UserDefaults.standard.array(forKey: "comingSoonTitles") as? [String]  else { return [] }
        return titles
    }
    
    func getFavoriteMovies() -> [String] {
        guard let titles = UserDefaults.standard.array(forKey: "favoriteMovies") as? [String]  else { return [] }
        return titles
    }
    
    // MARK:- setter functions
    func setPopularTitlesList(titles: [String]) {
        UserDefaults.standard.set(titles, forKey: "popularTitles")
    }
    
    func setComingSoonitlesList(titles: [String]) {
        UserDefaults.standard.set(titles, forKey: "comingSoonTitles")
    }
    
    func setFavoriteMovies(titles: [String]) {
        UserDefaults.standard.set(titles, forKey: "favoriteMovies")
    }
    
    
    // MARK:- favorite Movies
    @discardableResult
    func toggleFavorites(titleId: String) -> Bool {
        let favorites = getFavoriteMovies()
        if (favorites.contains(titleId)) {
            self.removeMovieFromFavorites(titleId: titleId, favorites: favorites)
            return false
        } else {
            self.addMovieToFavorites(titleId: titleId, favorites: favorites)
            return true
        }
    }
    
    @discardableResult
    func checkIfFavorite(titleId: String) ->Bool {
        let favorites = getFavoriteMovies()
        if (favorites.contains(titleId)) {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    func addMovieToFavorites(titleId: String, favorites: [String]) -> Bool {
        var newFavorites = favorites
        newFavorites.append(titleId)
        self.setFavoriteMovies(titles: newFavorites)
        return true
    }
    
    @discardableResult
    func removeMovieFromFavorites(titleId: String, favorites: [String]) -> Bool {
        self.setFavoriteMovies(titles: favorites.filter( {$0 != titleId} ))
        return true
    }
    
    func clearUserDefaults() {
        UserDefaults.resetStandardUserDefaults()
    }
}
