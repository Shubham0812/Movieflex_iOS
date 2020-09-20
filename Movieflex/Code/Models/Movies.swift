//
//  Movies.swift
//  Movieflex
//
//  Created by Shubham Singh on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Foundation

// Movie Search
struct SearchIds: Decodable {
    let id: String
}

struct TitlePoster: Decodable {
    let height: Double
    let width: Double
    let url: String
}

struct TitleInfo: Decodable {
    let runningTimeInMinutes: Int?
    let title: String
    let titleType: String
    let year: Int?
    let image: TitlePoster
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

// Title Detail
struct TitleDetail: Decodable {
    let id: String
    let title: TitleData
    let releaseDate: String
    let plotOutline: TitlePlot
    
    
    struct TitleData: Decodable {
        let runningTimeInMinutes: Double
        let year: Int
    }
    
    struct TitlePlot: Decodable {
        let author: String
        let text: String
    }
}


