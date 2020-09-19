//
//  NetworkManager.swift
//  Movieflex
//
//  Created by Shubham Singh on 15/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import Alamofire
import UIKit

enum APIError: String {
    case networkError
    case apiError
    case decodingError
}

enum APIs: URLRequestConvertible  {
    
    // MARK:- cases containing APIs
    case titleautocomplete(query: String)
    case popularTitles(regionCode: String)
    case moviesComingSoon
    case getTitleMetaData(titleIds: [String])
    
    
    // MARK:- variables
    static let endpoint = URL(string: "https://imdb8.p.rapidapi.com")!
    static let apiKey = "900b3906b7mshf8022684541b5cbp120f12jsn83c43a13c786"
    static let apiHost = "imdb8.p.rapidapi.com"
    
    var path: String {
        switch self {
        case .titleautocomplete(_):
            return "/title/auto-complete"
        case .popularTitles(_):
            return "/title/get-most-popular-movies"
        case .moviesComingSoon:
            return "/title/get-coming-soon-movies"
        case .getTitleMetaData(_):
            return "/title/get-meta-data"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding : URLEncoding {
        return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets)
    }
    
    func addApiHeaders(request: inout URLRequest) {
        request.addValue(Self.apiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.addValue(Self.apiKey, forHTTPHeaderField: "x-rapidapi-key")
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Self.endpoint.appendingPathComponent(path))
        var parameters = Parameters()
        
        switch self {
        case .titleautocomplete(let query):
            parameters["q"] = query
        case .popularTitles(let regionCode):
            parameters["currentCountry"] = regionCode
        case .getTitleMetaData(let titleIds):
            parameters["ids"] = titleIds
        default: break
        }
        
        addApiHeaders(request: &request)
        request.addValue("iphone", forHTTPHeaderField: "User-Agent")
        request = try encoding.encode(request, with: parameters)
        return request
    }
}


struct NetworkManager {
    
    let jsonDecoder = JSONDecoder()
    let fileHandler = FileHandler()
    let imageCompressionScale: CGFloat = 0.25
    
    // functions to call the APIs
    func getTitlesAutocomplete(query: String, completion: @escaping([AutoCompleteTitle]?, APIError? ) -> ()) {
        Alamofire.request(APIs.titleautocomplete(query: query)).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let jsonData):
                if let payload = jsonData as? [String:Any], let arrayData = payload["d"], let jsonData = try? JSONSerialization.data(withJSONObject: arrayData, options: .sortedKeys)  {
                    do {
                        let titles = try jsonDecoder.decode([AutoCompleteTitle].self, from: jsonData)
                        completion(titles, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    func getPopularTitles(completion: @escaping([String]?, APIError?) -> ()) {
        Alamofire.request(APIs.popularTitles(regionCode: "IN")).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys)  {
                    do {
                        let popularTitles = try jsonDecoder.decode([String].self, from: jsonData)
                        completion(popularTitles.map { $0.components(separatedBy: "/")[2] }, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    func getComingSoonTitles(completion: @escaping([String]?, APIError?) -> ()) {
        Alamofire.request(APIs.moviesComingSoon).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys)  {
                    do {
                        let popularTitles = try jsonDecoder.decode([String].self, from: jsonData)
                        completion(popularTitles.map { $0.components(separatedBy: "/")[2] }, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    func getTitlesMetaData(titleIds: [String], completion: @escaping([TitleMetaData]?, APIError?) -> ()) {
        Alamofire.request(APIs.getTitleMetaData(titleIds: titleIds)).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let jsonData):
                if let payload = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys) {
                    do {
                        let decodedData = try jsonDecoder.decode(DecodedTitleMetaData.self, from: payload)
                        completion(decodedData.titlesMetaData, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    func downloadMoviePoster(url: URL, titleId: String, completion: @escaping(URL?, APIError?) -> ()) {
        Alamofire.request(URLRequest(url: url)).validate().responseData { res in
            switch res.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let imageData):
                guard let image = UIImage(data: imageData), let compressedData = image.jpegData(compressionQuality: imageCompressionScale) else { return }
                do {
                    try compressedData.write(to: fileHandler.getPathForImage(titleId: titleId))
                    completion(fileHandler.getPathForImage(titleId: titleId), nil)
                } catch {
                    print(error)
                    completion(nil, .decodingError)
                }
            }
        }
    }
}

