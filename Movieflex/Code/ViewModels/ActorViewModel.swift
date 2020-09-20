//
//  ActorViewModel.swift
//  Movieflex
//
//  Created by Shubham Singh on 20/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct ActorViewModel {
    // MARK:- variable for the viewModel
    let fileHandler: FileHandler
    let networkManager: NetworkManager
    
    let imageUrlString: String
    let name: String
    let birthDate: String
    let birthPlace: String
    let gender: String
    let id: String
    
    let movies: ActorFilms
    
    var totalMovies: Int {
        movies.filmography.count
    }
    
    var actorImageUrl: URL {
        guard let url = URL(string: imageUrlString) else { return URL(string: "")! }
        return url
    }
    
    var actorImage: BoxBind<UIImage?> = BoxBind(nil)
    var isFavorite: BoxBind<Bool?> = BoxBind(nil)
    
    // MARK:- initializers for the viewModel
    init(actor: Actor?, actorFilms: ActorFilms, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        
        if let actor = actor {
            birthDate = actor.birthDate
            birthPlace = actor.birthPlace
            gender = actor.gender
        } else {
            birthDate = ""
            birthPlace = ""
            gender = ""
        }
        id = actorFilms.base.id.components(separatedBy: ",")[2]
        imageUrlString = actorFilms.base.image.url
        name = actorFilms.base.name
        movies = actorFilms
        
        self.fileHandler = handler
        self.networkManager = networkManager
        
        self.getActorImage()
    }
    
    // MARK:- functions for the viewModel
    func getActorImage() {
        if (fileHandler.checkIfFileExists(id: id)) {
            self.actorImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
        } else {
            networkManager.downloadMoviePoster(url: self.actorImageUrl, id: self.id) { res, error in
                if (error == .none) {
                    self.actorImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
                }
            }
        }
    }
}


struct ActorListViewModel {
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    let fileHandler: FileHandler
    let favoriteType: UserDefaultsManager.Favorites = .favoriteActors
    
    let movieId: String
    var offset: Int = 0
    var limit: Int = 1
    
    var actors: BoxBind<[String]?> = BoxBind(nil)
    
    var actorsForMovie: BoxBind<[ActorViewModel]?> = BoxBind(nil)
    var favoriteActor:BoxBind<[ActorViewModel]?> = BoxBind(nil)
    
    // MARK:- initializers for the viewModel
    init(movieId: String = "", handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager(), defaultsManager: UserDefaultsManager = UserDefaultsManager()) {
        self.defaultsManager = defaultsManager
        self.networkManager = networkManager
        self.fileHandler = handler
        self.movieId = movieId
        
        
        self.getActorsForMovie()
    }

    // MARK:- functions for the viewModel
    func getActorsForMovie() {
        networkManager.getCastForTitle(titleId: movieId) { res, error in
            guard let casts = res else { return }
            let initialDisplayCasts = casts[offset..<limit]
            
            DispatchQueue.global(qos: .default).async {
                for cast in initialDisplayCasts {
                    networkManager.getMoviesForActor(actorId: cast) { res, error in
                        print("The filmu data", res)
                    }
                }
            }
        }
    }
}

extension ActorListViewModel {
    func likePressed(id: String) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(id: id, type: .favoriteActors)
        if (buttonStatus) {
            return true
        } else {
            return false
        }
    }
}
