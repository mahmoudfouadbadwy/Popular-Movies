//
//  BindDetailsData.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 6/19/20.
//  Copyright © 2020 Mahmoud fouad. All rights reserved.
//

import Foundation
extension MovieDetailsController{
    
    func bindDetails()
    {
        movieName.text = self.movie.title
    movieImage!.sd_setImage(with:URL(string:Constants.imagePath+self.movie.poster),completed: nil)
        movieOverview.text = self.movie.overview
        MovieDate.text = self.movie.release

        cosmosview.settings.fillMode = .precise
        cosmosview.rating = (self.movie.rate) / 2.0
        cosmosview.isUserInteractionEnabled = false
    }
    
}
