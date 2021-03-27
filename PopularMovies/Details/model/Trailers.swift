//
//  Trailers.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/27/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import Foundation

enum Trailer {
    struct Request {
        
    }
    
    struct Response: Codable {
        let id: Int
        let results: [Result]
    }
    struct Result: Codable {
        let id, iso639_1, iso3166_1, key: String
        let name, site: String
        let size: Int
        let type: String

        enum CodingKeys: String, CodingKey {
            case id
            case iso639_1 = "iso_639_1"
            case iso3166_1 = "iso_3166_1"
            case key, name, site, size, type
        }
    }
    
    
    struct viewModel {
        let key: String
        let name: String
    }
    
}

