//
//  NetworkModel.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/6/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import ReachabilitySwift
class NetworkModel: NSObject {
    func checkNetwork()->Bool {
        let reachability =  Reachability()
        if (reachability?.isReachable)!{
          return true
        }
        else
        {
            return false
        }
    }
    
}
