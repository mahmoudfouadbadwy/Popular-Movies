//
//  YoutubeCell.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/4/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit

class TrailerCell: UICollectionViewCell {

    @IBOutlet weak private var trailerImage: UIButton!
    @IBOutlet weak private var trailerName: UILabel!
    
    override func prepareForInterfaceBuilder() {
        trailerImage.layer.cornerRadius = 10
    }
    
    func config(title: String) {
        trailerName.text = title
    }
}
