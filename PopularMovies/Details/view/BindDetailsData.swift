//
//  BindDetailsData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/19/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
import UIKit
extension MovieDetailsController{
    
    func bindDetails()
    {
        movieName.text = self.movie.title
    movieImage!.sd_setImage(with:URL(string:Constants.imagePath+self.movie.poster),completed: nil)
        movieOverview.text = self.movie.overview
        movieDate.text = self.movie.release
        cosmosview.settings.fillMode = .precise
        cosmosview.rating = (self.movie.rate) / 2.0
        cosmosview.isUserInteractionEnabled = false
        if self.movieCoreVM.checkIsFavoriteMovie(movieID: filmId) != 0
        {
            favButton.tintColor = UIColor.red
        }
    }
    
}
