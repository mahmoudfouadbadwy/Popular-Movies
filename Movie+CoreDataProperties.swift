//
//  Movie+CoreDataProperties.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 22/01/2022.
//  Copyright © 2022 Mahmoud fouad. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var mRelease: String?
    @NSManaged public var name: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var rate: Double

}

extension Movie : Identifiable {

}
