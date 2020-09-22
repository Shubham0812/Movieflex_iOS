//
//  MovieflexTests.swift
//  MovieflexTests
//
//  Created by Shubham Singh on 15/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import XCTest
@testable import Movieflex

class MovieflexTests: XCTestCase {
    
    let handler = FileHandler()
    let networkManager = NetworkManager()
    let defaultsManager = UserDefaultsManager()
    
    var movieListVM: MovieListViewModel  {
        return MovieListViewModel(defaultsManager: UserDefaultsManager(), networkManager: NetworkManager(), handler: FileHandler())
    }
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
    }
    
    // MovieListViewModel Tests
    func testPopularTitlesFetch() {
        movieListVM.popularMovies.bind {
            guard let movieTitles = $0 else { return }
            assert(!movieTitles.isEmpty)
        }
    }
    
    // API Tests
    /// This is how you test APIs. Set up a response and an expectation. Set a timeout and if the API doesn't return the call, it fails. Afterwards you can use XCTAsserts to test you cases
    func testFilmsForActor() {
        let actorId = "nm1869101"
        var actorResponse: ActorFilms? = nil
        let actorExpectation = expectation(description: "actor films")
        networkManager.getMoviesForActor(actorId: actorId) { res, error in
            actorResponse = res
            actorExpectation.fulfill()
        }
        self.waitForExpectations(timeout: 5) { _ in
            print(actorResponse as Any)
            XCTAssertNotNil(actorResponse)
        }
    }
    
    // User Defaults
    func testFavoriteMovies() {
        let favoriteMovies = defaultsManager.getFavorites(type: Favorites.favoriteMovies)
        print(favoriteMovies)
        XCTAssertNotNil(favoriteMovies)
    }
    
    func testFavoriteActors() {
        let favoriteActors = defaultsManager.getFavorites(type: Favorites.favoriteActors)
        print(favoriteActors)
        XCTAssertNotNil(favoriteActors)
    }
    
    // FileManager
    func testDocumentsDirectory() {
        print(handler.documentsDirectory)
        assert(!handler.documentsDirectory.absoluteString.isEmpty)
    }
    
    func testContentsOfDocumentDirectory() {
        assert(handler.flushDocumentsDirectory() == true)
    }
}
