//
//  ActorListViewModel.swift
//  Movieflex
//
//  Created by Shubham Singh on 21/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

struct ActorListViewModel {
    
    enum ListType {
        case actorsForMovie
        case favoriteActors
    }
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    let fileHandler: FileHandler
    
    /// Limiting the actors count to 5, since the api doesn't support multiple ids, calling APIs without the limit, easily exahauts the 500 API call / month free limit of the site.
    /// I do wish that it was more though, sigh.
    let movieId: String
    var offset: Int = 0
    var limit: Int = 5
    
    
    var actors: BoxBind<[String]?> = BoxBind(nil)
    var prefetch: BoxBind<Bool> = BoxBind(false)
    
    var noData: BoxBind<(ListType?)> = BoxBind(nil)
    
    
    var actorsForMovie: BoxBind<[ActorViewModel]?> = BoxBind([ActorViewModel](repeating: ActorViewModel(actorFilms: nil), count: 5))
    var favoriteActors: BoxBind<[ActorViewModel]?> = BoxBind(nil)
    
    // MARK:- initializers for the viewModel
    init(movieId: String = "", handler: FileHandler, networkManager: NetworkManager, defaultsManager: UserDefaultsManager) {
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
                /// I don't like this at all, I wish they had given a way to pass mutiple actor ids at once. -_-
                for cast in initialDisplayCasts {
                    networkManager.getMoviesForActor(actorId: cast) { res, error in
                        guard let actorFilms = res else { return }
                        if (!self.prefetch.value){
                            DispatchQueue.main.async {
                                self.actorsForMovie.value = nil
                                self.prefetch.value = true
                            }
                        }
                        if var actorsList = self.actorsForMovie.value {
                            actorsList.append(ActorViewModel(actorFilms: actorFilms))
                            self.actorsForMovie.value = actorsList
                        } else {
                            self.actorsForMovie.value = [ActorViewModel(actorFilms: actorFilms)]
                        }
                    }
                }
            }
        }
    }
    
    func getFavoriteActors() {
        let favorties = defaultsManager.getFavorites(type: favoriteType)
        if (favorties.isEmpty) {
            self.noData.value = .favoriteActors
        }
        DispatchQueue.global(qos: .default).async {
            /// I don't like this at all, I wish they had given a way to pass mutiple actor ids at once. -_-
            if let favoritesArray = self.favoriteActors.value {
                if (favoritesArray.count == favorties.count) {
                    return
                }
            }
            for cast in favorties {
                networkManager.getMoviesForActor(actorId: cast) { res, error in
                    guard let actorFilms = res else { return }
                    if var actorsList = self.favoriteActors.value {
                        actorsList.append(ActorViewModel(actorFilms: actorFilms))
                        self.favoriteActors.value = actorsList
                    } else {
                        self.favoriteActors.value = [ActorViewModel(actorFilms: actorFilms)]
                    }
                }
            }
        }
    }
    
    func getCountForDisplay(type: ListType) -> Int {
        if (type == .actorsForMovie) {
            guard let actorViewModels =  self.actorsForMovie.value else { return 0 }
            return actorViewModels.count
        } else {
            guard let actorViewModels = self.favoriteActors.value else { return 0 }
            return actorViewModels.count
        }
    }
    
    func prepareCellForDisplay(collectionView: UICollectionView, indexPath: IndexPath, actorViewModel: ActorViewModel, withFavorite: Bool = true) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorCollectionViewCell.description(), for: indexPath) as? ActorCollectionViewCell {
            cell.actorListViewModel = self
            cell.setupCell(viewModel: actorViewModel, showFavorites: withFavorite)
            return cell
        }
        fatalError()
    }
}

extension ActorListViewModel: Likeable {
    var favoriteType: Favorites  {
        .favoriteActors
    }
    
    func likePressed(id: String) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(id: id, type: favoriteType)
        self.getFavoriteActors()
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

