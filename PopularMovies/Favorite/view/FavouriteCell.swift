//
//  FavouriteCell.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/6/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import SDWebImage

class FavouriteCell: UICollectionViewCell {
    
    @IBOutlet weak private var favouriteImage: UIImageView!
    
    func configer(poster: String) {
        favouriteImage.sd_setImage(with: URL(string: Constants.imagePath + poster), placeholderImage: UIImage.init(named: "loading.png"))
    }
}
