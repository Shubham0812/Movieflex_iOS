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
    
    //MARK:- setter functions
    func setPopularTitlesList(popularTitles: [String]) {
        UserDefaults.standard.set(popularTitles, forKey: "popularTitles")
    }
    
    
    func clearUserDefaults() {
        UserDefaults.resetStandardUserDefaults()
    }
}
