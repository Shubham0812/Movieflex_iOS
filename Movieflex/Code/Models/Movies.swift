//
//  Movies.swift
//  Movieflex
//
//  Created by Shubham Singh on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation

// Movie Search
struct AutoCompleteTitle: Decodable {
    let id: String
    let name: String
    let type: String?
    let rank: Int
    let starring: String
    let poster: TitlePoster
    let year: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "l"
        case type = "q"
        case rank = "rank"
        case starring = "s"
        case poster = "i"
        case year = "y"
    }
}

struct TitlePoster: Decodable {
    let height: Double
    let width: Double
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case height = "height"
        case width = "width"
        case url = "imageUrl"
    }
}

// MARK:- Title Meta Data
struct TitleInfo: Decodable {
    let runningTimeInMinutes: Int?
    let title: String
    let titleType: String
    let year: Int
    let image: TitlePoster
    
    // MARK:- had to write this again,the meta-data API contains the url in a `url` key instead of `imageUrl`. P.S. - If you're making your own APIs, make sure to have consitency, it always helps in the long run.
    struct TitlePoster: Decodable {
        let height: Double
        let width: Double
        let url: String
    }
}

struct TitleRating: Decodable {
    let rating: Double?
    let ratingCount: Int?
    let topRank: Int?
    let bottomRank: Int?
}

struct TitleMetaData: Decodable {
    let title: TitleInfo
    let titleId: String
    let ratings: TitleRating
    let releaseDate: String
    let genres: [String]
    
    enum CodingKeys: CodingKey {
        case title,titleId, ratings, releaseDate, genres
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(TitleInfo.self, forKey: .title)
        ratings = try container.decode(TitleRating.self, forKey: .ratings)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
        genres = try container.decode([String].self, forKey: .genres)
        
        titleId = container.codingPath.first!.stringValue
    }
}

struct DecodedTitleMetaData: Decodable {
    var titlesMetaData: [TitleMetaData]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [TitleMetaData]()
        for key in container.allKeys {
            let decodedObject = try container.decode(TitleMetaData.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        titlesMetaData = tempArray
    }
}
