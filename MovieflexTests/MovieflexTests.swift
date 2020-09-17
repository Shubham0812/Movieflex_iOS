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
    
    var movieListVM: MovieListViewModel  {
        return MovieListViewModel(defaultsManager: UserDefaultsManager(), networkManager: NetworkManager())
    }
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
    }
    
    // MovieListViewModel Tests
    func testPopularTitlesFetch() {
        movieListVM.getPopularMovieTitles(offset: 0, limit: 10) { res in
            print("test", res)
            precondition(!res!.isEmpty, "Popular movies array is empty")
        }
    }
}
