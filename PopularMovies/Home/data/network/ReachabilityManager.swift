//
//  ReachabilityManager.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/12/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//


import ReachabilitySwift

// App wide protocol for listening to network status changes
public protocol NetworkStatusListener: class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class ReachabilityManager: NSObject {
    
    // Shared instance
    static  let shared = ReachabilityManager()
    
    // Boolean to track network reachability
    var isNetworkAvailable: Bool {
        return reachabilityStatus != .notReachable
    }
    
    // Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    // Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    // Array of delegates which are interested in listening to network status changes
    var listeners = [NetworkStatusListener]()
    
    // Called whenever there is a change in NetworkReachibility Status
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            DispatchQueue.main.async {
//                MessageDialog.showNotification(type: "bad", title: "No Internet Connection", message: "Turn on Mobile Data or Wifi to use the app.", dismissDelay: 0)
                print("no connection")
                
               // self.connectivity.tintColor = UIColor.red
            }
        case .reachableViaWiFi:
            DispatchQueue.main.async {
                // Don't do anything here
          //      print(" connection www")
               // self.connectivity.tintColor = UIColor.green
            }
        case .reachableViaWWAN:
            DispatchQueue.main.async {
                // Don't do anything here
          //      print(" connection nn")
              //  self.connectivity.tintColor = UIColor.green
            }
        }
        
        // Sending messages to each of the listening delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }
    
    // Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }
    
    // Stops monitoring the network availability status
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    // Adds a new listener to the listeners array
    func addListener(listener: NetworkStatusListener) {
        listeners.append(listener)
    }
    
    // Removes a listener from listeners array
    func removeListener(listener: NetworkStatusListener) {
        listeners = listeners.filter{ $0 !== listener}
    }
}
