//
//  MoviesNetwork.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/10/21.
//  Copyright © 2021 Mahmoud Fouad. All rights reserved.
//

import Foundation
import ReachabilitySwift
import RxSwift


class MoviesService {
    
    static func loadData(requestUrl: String) -> Observable<[Movie]> {
        
        return  Observable<[Movie]>.create { observer in
            
            let url = URL(string: requestUrl)!
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(MoviesData.self, from: data)
                        print("🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯")
                        print(result)
                        observer.onNext(result.movies)
                        observer.onCompleted()
                    } catch let error {
                        print("🧨🧨🧨🧨🧨🧨🧨🧨🧨🧨🧨")
                        print(error)
                        observer.onError(MoviesException.server)
                    }
                } else {
                    print("💊💊💊💊💊💊💊💊💊💊💊💊")
                    observer.onError(MoviesException.network)
                }
            }
            
            task.resume()
            
            return Disposables.create()
        }
    }
}

enum MoviesException: Error {
    case network
    case server
}

struct Networking {
    static var isNetworkEnabled: Bool {
        Reachability()?.isReachable ?? false
    }
}


