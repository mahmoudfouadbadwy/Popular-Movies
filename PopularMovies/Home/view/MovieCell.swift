//
//  MovieCell.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {
 
    @IBOutlet private weak var poster: UIImageView!
    
    func configCell(imagePath: String) {
        poster.sd_setImage(with: URL(string: Constants.imagePath + imagePath), placeholderImage: UIImage.init(named: "loading.png"))
    }
}
