//
//  RevCell.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/10/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    
    @IBOutlet weak private var reviewContent: UITextView!
    @IBOutlet weak private var reviewerName: UILabel!
    
    func config(name: String, content: String) {
        reviewContent.text = content
        reviewerName.text = name
    }
}
