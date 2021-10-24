//
//  Movies+CoreDataProperties.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 10/23/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//
//

import Foundation
import CoreData


extension Movies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movies> {
        return NSFetchRequest<Movies>(entityName: "Movies")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var mRelease: String?
    @NSManaged public var name: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var rate: Double

}
