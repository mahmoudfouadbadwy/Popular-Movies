//
//  MovieDetail.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 1/3/20.
//  Copyright © 2020 Mahmoud Fouad. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import RxCocoa
import RxSwift


class MovieDetailsController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak private var cosmosView: CosmosView!
    @IBOutlet weak private var movieOverview: UITextView!
    @IBOutlet weak private var movieName: UILabel!
    @IBOutlet weak private var movieImage: UIImageView!
    @IBOutlet weak private var movieDate: UILabel!
    @IBOutlet weak private var favButton: UIButton!
    @IBOutlet weak private var TrailersBtn: UIButton!
    @IBOutlet weak private var ReviewsBtn: UIButton!
    @IBOutlet weak private var moreStack: UIStackView!
    
    //MARK:- Properties
    var movieID: Int!
    private var viewModel: MoviewDetailsBusiness = MovieDetailsViewModel()
    private let bag = DisposeBag()
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)
    private var isFavorite: Bool?
    private var movie: MovieDetailsData.Response?
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        isFavorite = viewModel.checkIsFavorite(movieId: movieID)
        viewModel.getMovieDetails(MovieId: movieID)
        bindeMovieDetails()
        favoriteAction()
        showReviews()
        showTrailers()
    }

    //MARK:- Actions
    func favoriteAction() {
        favButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self ] in
                guard let self = self else { return }
                if  self.favButton.tintColor == .red {
                    self.favButton.tintColor = .white
                    self.viewModel.unFavorite()
                }
                else {
                    self.favButton.tintColor = .red
                    self.viewModel.makeFavorite()
                }
            })
            .disposed(by: bag)
    }
    
    
    
    //MARK:- UI
    private func setupUI() {
        self.navigationItem.title = "Details"
        self.cosmosView.settings.fillMode = .precise
        self.cosmosView.isUserInteractionEnabled = false
        indicator.center = view.center
        indicator.color = .red
        self.view.addSubview(indicator)
        
    }
    
    //MARK:- UI Logic
    private func bindeMovieDetails() {
        indicator.startAnimating()
        viewModel
            .movieDetails
            .subscribe(onNext: { [weak self] movie in
                self?.indicator.stopAnimating()
              //  self?.moreStack.isHidden = false
                self?.movie = movie
                self?.movieName.text = movie.originalTitle
                self?.movieImage.sd_setImage(with: URL(string: Constants.imagePath + movie.posterPath), placeholderImage: UIImage(named: "loading"))
                self?.movieOverview.text = movie.overview
                self?.movieDate.text = movie.releaseDate
                self?.cosmosView.rating = (movie.voteAverage) / 2.0
                self?.setupFavoriteBtn()
            })
            .disposed(by: bag)
    }
    
    private func setupFavoriteBtn() {
        favButton.tintColor = (isFavorite ?? false) ? .red : .white
    }
    
    private func showReviews() {
        ReviewsBtn
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.routeToReviews()
            })
        .disposed(by: bag)
    }
    
    private func showTrailers() {
        TrailersBtn
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.routeToTrailers()
            })
        .disposed(by: bag)
    }
    
    private func routeToReviews() {
        guard let reviewsController = UIStoryboard(name: "Main",
                                                   bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as? ReviewsViewController else { return }
        reviewsController.movieID = movieID
        self.navigationController?.pushViewController(reviewsController, animated: true)
    }
    
    private func routeToTrailers() {
        guard let trailerController =  UIStoryboard(name: "Main",
                                                    bundle: nil).instantiateViewController(withIdentifier: "TrailersViewController") as? TrailersViewController else { return }
        trailerController.movieId = movieID
        self.navigationController?.pushViewController(trailerController, animated: true)
    }
}
