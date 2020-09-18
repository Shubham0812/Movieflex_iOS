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
    
    
    // FileManager
    func testDocumentsDirectory() {
        print(handler.documentsDirectory)
        assert(!handler.documentsDirectory.absoluteString.isEmpty)
    }
    
    func testContentsOfDocumentDirectory() {
        assert(handler.flushDocumentsDirectory() == true)
    }
}
