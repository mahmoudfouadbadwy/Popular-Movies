//
//  Movie+CoreDataClass.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 22/01/2022.
//  Copyright © 2022 Mahmoud fouad. All rights reserved.
//
//

import Foundation
import CoreData


public class Movie: NSManagedObject {
        
        var identifier: Int {
            Int(id)
        }
        var relase: String {
            mRelease ?? ""
        }
        
        var title: String {
            name ?? ""
        }
       
        var notes: String {
            overview ?? ""
        }
      
        var image: String {
            poster ?? ""
        }

}
