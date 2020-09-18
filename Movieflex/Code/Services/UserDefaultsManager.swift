//
//  UserDefaultsManager.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation


class UserDefaultsManager {
    
    //MARK:- getter functions
    func getPopularTitlesList() -> [String] {
        guard let titles = UserDefaults.standard.array(forKey: "popularTitles") as? [String]  else { return [] }
        return titles
    }
    
    func getComingSoonTitlesList() -> [String] {
        guard let titles = UserDefaults.standard.array(forKey: "comingSoonTitles") as? [String]  else { return [] }
        return titles
    }
    
    //MARK:- setter functions
    func setPopularTitlesList(titles: [String]) {
        UserDefaults.standard.set(titles, forKey: "popularTitles")
    }
    
    func setComingSoonitlesList(titles: [String]) {
        UserDefaults.standard.set(titles, forKey: "comingSoonTitles")
    }
    
    func clearUserDefaults() {
        UserDefaults.resetStandardUserDefaults()
    }
}
