//
//  CollectionViewExtension.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 4/3/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseIdentifier: String {get}
}


extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ class: T.Type)  {
        register(`class`, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
}
