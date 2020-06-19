//
//  NetworkListener.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/8/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import ReachabilitySwift
extension Home: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        switch status {
        case .notReachable:
            DispatchQueue.main.async{
                print("not reachable")
                self.connectivity.tintColor = UIColor.red
                self.movies = self.localHomeVM.getLocalMovies()
            }
        case .reachableViaWiFi:
            DispatchQueue.main.async {
                print(" reachable wifi")
                self.connectivity.tintColor = UIColor.green
                self.homeVM.getmovies(by: Constants.imagePath, appendFlag: 0, completion: {[weak self] results in
                    self?.movies = results
                })
            }
        case .reachableViaWWAN:
            DispatchQueue.main.async {
                 print(" reachable WWAN")
                self.connectivity.tintColor = UIColor.green
                self.homeVM.getmovies(by: Constants.imagePath, appendFlag: 0, completion: {[weak self] results in
                    self?.movies = results
                })

            }
        }
    }
}
