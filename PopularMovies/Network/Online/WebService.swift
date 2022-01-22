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
import Combine

class WebService {
    private let decoder = JSONDecoder()
    private let serviceQueue = DispatchQueue(label: "Api", qos: .background, attributes: .concurrent)
    private var subscribtion = Set<AnyCancellable>()
    
    static func makeRequest<T: Codable>(requestUrl: String) -> Observable<T> {
        
        return  Observable<T>.create { observer in
            
            let url = URL(string: requestUrl)!
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let data = data {
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
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
        .observeOn(MainScheduler.instance)
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}

extension WebService {
    func makeRequest<T: Codable>(url: String) -> AnyPublisher<T, Exception> {
        return Future { [weak self ] promise in
            guard let url = URL(string: url),
                  let self = self else {
                      print("💊💊💊💊💊💊💊💊💊💊💊💊")
                      return promise(.failure(Exception.server))
                  }
            URLSession
                .shared
                .dataTaskPublisher(for: url)
                .receive(on: self.serviceQueue)
                .map(\.data)
                .decode(type: T.self, decoder: self.decoder)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print("🧨🧨🧨🧨🧨🧨🧨🧨🧨🧨🧨")
                        print(error)
                        promise(.failure(Exception.server))
                    }
                } receiveValue: { result in
                    promise(.success(result))
                }
                .store(in: &self.subscribtion)
        }
        .eraseToAnyPublisher()
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


