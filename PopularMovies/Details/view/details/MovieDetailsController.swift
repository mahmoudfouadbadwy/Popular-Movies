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
    
    //MARK: - IBOutlets
    @IBOutlet weak private var cosmosView: CosmosView!
    @IBOutlet weak private var movieOverview: UITextView!
    @IBOutlet weak private var movieImage: UIImageView!
    @IBOutlet weak private var movieDate: UILabel!
    @IBOutlet weak private var favButton: UIButton!
    @IBOutlet weak private var TrailersBtn: UIButton!
    @IBOutlet weak private var ReviewsBtn: UIButton!
    @IBOutlet weak private var moreStack: UIStackView!
    
    //MARK: - Properties
    var viewModel: (MoviewDetailsBusiness & MovieReviewsBusiness & MoviewTrailersBusiness)?
    private let bag = DisposeBag()
    private var indicator: UIActivityIndicatorView!
    private var movie: MovieDetailsData.ViewModel?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindeMovieDetails()
        favoriteAction()
        showReviews()
        showTrailers()
    }
    
    //MARK: - Actions
    func favoriteAction() {
        favButton
            .rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self ] in
                guard let self = self,
                      let viewModel = self.viewModel else { return }
                if self.favButton.tintColor == .red {
                    self.favButton.tintColor = .white
                    viewModel.unFavorite()
                } else {
                    self.favButton.tintColor = .red
                    viewModel.makeFavorite()
                }
            })
            .disposed(by: bag)
    }
    
    
    
    //MARK: - UI
    private func setupUI() {
        self.title = Strings.Title.details
        self.cosmosView.settings.fillMode = .precise
        self.cosmosView.isUserInteractionEnabled = false
        indicator =  UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.color = .red
        self.view.addSubview(indicator)
        
    }
    
    //MARK: - UI Logic
    private func bindeMovieDetails() {
        indicator.startAnimating()
        viewModel?
            .movieDetails
            .subscribe(onNext: { [weak self] movie in
                self?.indicator.stopAnimating()
                self?.moreStack.isHidden = false
                self?.movie = movie
                self?.title = movie.originalTitle
                self?.movieImage.sd_setImage(with: URL(string: Strings.URL.imagePath + movie.moviePoster), placeholderImage: UIImage(named: Strings.Image.loading))
                self?.movieOverview.text = movie.overview
                self?.movieDate.text = movie.releaseDate
                self?.cosmosView.rating = (movie.voteAverage) / 2.0
                self?.setupFavoriteBtn()
            })
            .disposed(by: bag)
    }
    
    private func setupFavoriteBtn() {
        guard let viewModel = viewModel else { return }
        favButton.tintColor = viewModel.checkIsFavorite() ? .red : .white
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
        guard let reviewsController = getController(ReviewsViewController.self, fromBoard: "Main") else { return }
        
        reviewsController.viewModel = viewModel
        self.navigate(to: reviewsController)
    }
    
    private func routeToTrailers() {
        guard let trailerController =  getController(TrailersViewController.self, fromBoard: "Main") else { return }
        trailerController.viewModel = viewModel
        self.navigate(to: trailerController)
    }
}
