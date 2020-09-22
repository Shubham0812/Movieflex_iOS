//
//  Generic.swift
//  Movieflex
//
//  Created by Shubham Singh on 20/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

enum Favorites: String {
    case favoriteActors
    case favoriteMovies
}

struct Generic {
    let colors = [UIColor.systemRed, UIColor.systemTeal, UIColor.systemIndigo, UIColor.systemOrange, UIColor.systemGreen, UIColor.systemYellow]
    
    static var shared: Generic {
        return Generic()
    }
    
    func getRandomColor() -> UIColor {
        return colors.randomElement()!
    }
}


protocol CollectionViewShimmers {
    var animationDuration: Double { get }

    func hideViews()
    func showViews()    
    func setShimmer()
    func removeShimmer()
}

protocol Likeable {
    var favoriteType: Favorites { get }
    
    func likePressed(id: String) -> Bool
    func checkIfFavorite(id: String) -> Bool
}
