//
//  GifManager.swift
//  gif-me
//
//  Created by Raitis Saripo on 19/04/2021.
//

import Foundation
import Alamofire

struct GifManager {
    
    let searchURL = "https://api.giphy.com/v1/gifs/search"
    let trendingURL = "https://api.giphy.com/v1/gifs/trending"
    var URL = ""
    var parameters: [String: String] = [:]
    
    mutating func fetchData(searchQuery: String? = nil, offset: Int? = nil, completion: @escaping ([Gif]) -> ()) {
        let searchParameters : [String: String] = [
            "api_key": K.apiKey,
            "q": searchQuery ?? "",
            "offset": String(offset ?? 0),
            "limit": "10",
            "rating": "g"
        ]
        
        let trendingParameters: [String: String] = [
            "api_key": K.apiKey,
            "limit": "40",
            "rating": "g"
        ]
        
        if offset != nil {
            self.URL = searchURL
            self.parameters = searchParameters
        } else {
            self.URL = trendingURL
            self.parameters = trendingParameters
        }
        
        AF.request(URL, method: .get, parameters: parameters).responseDecodable(of: GifList.self) { (response) in
            switch response.result {
            case let .success(value):
                //print(value)
                completion(value.data)
            case let .failure(error):
                print(error)
            }
        }
    }
}
