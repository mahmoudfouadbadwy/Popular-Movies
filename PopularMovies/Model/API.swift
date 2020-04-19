//
//  API.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import UIKit
import AFNetworking
class API: NSObject {
var data:[Dictionary<String,Any>] = []
    func getdata(url:String,appendFlag:Int,completion:@escaping([Dictionary<String,Any>])-> Void)
    {
        let manager = AFHTTPSessionManager()
        manager.get(
            url,
            parameters: nil,
            success:
            {
                (operation, responseObject) in
                var dic:Dictionary<String,Any> = responseObject as! Dictionary<String,Any>
                let arr = dic["results"]  as! NSArray
                  if appendFlag == 0
                  {
                    self.data=[]
                  }
                for i in 0..<arr.count
                {
                    if let film = (arr[i] as? Dictionary<String,Any>)
                    {
                        self.data.append(film)
                    }
                    

                }
                 completion(self.data)
        },
            failure:
            {
                (operation, error) in
                print("Error: " + error.localizedDescription)
        })

    }
}
