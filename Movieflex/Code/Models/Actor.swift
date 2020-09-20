//
//  Actor.swift
//  Movieflex
//
//  Created by Shubham Singh on 20/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation

struct Actor: Decodable {
    let name: String
    let birthDate: String
    let birthPlace: String
    let gender: String
    let heightCentimeters: Int
}

struct ActorFilms: Decodable {
    let id: String
    let base: ActorBase
    let filmography: [ActorFilmography]
}

struct ActorBase: Decodable {
    let id: String
    let name: String
    let image: TitlePoster
}

struct ActorFilmography: Decodable {
    let category: String
    let characters: [String]?
    let image: TitlePoster?
    let status: String
    let title: String
    let titleType: String
    let year: Int?
}
