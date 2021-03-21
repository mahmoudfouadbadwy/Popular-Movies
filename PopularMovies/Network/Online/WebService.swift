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


class WebService {
    
    static func loadData<T: Codable>(requestUrl: String) -> Observable<T> {
        
        return  Observable<T>.create { observer in
            
            let url = URL(string: requestUrl)!
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        print("🎯🎯🎯🎯🎯🎯🎯🎯🎯🎯")
                        print(result)
                        observer.onNext(result)
                        observer.onCompleted()
                    } catch let error {
                        print("🧨🧨🧨🧨🧨🧨🧨🧨🧨🧨🧨")
                        print(error)
                        observer.onError(Exception.server)
                    }
                } else {
                    print("💊💊💊💊💊💊💊💊💊💊💊💊")
                    observer.onError(Exception.network)
                }
            }
            
            task.resume()
            
            return Disposables.create()
        }
    }
}

enum Exception: Error {
    case network
    case server
}

struct Networking {
    static var isNetworkEnabled: Bool {
        Reachability()?.isReachable ?? false
    }
}


