//
//  ReviewsViewController.swift
//  PopularMovies
//
//  Created by Mahmoud Fouad on 3/26/21.
//  Copyright © 2021 Mahmoud fouad. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak private var reviewsCollection: UICollectionView!
    
    //MARK: - Properties
    var viewModel: MovieReviewsBusiness!
    private let bag = DisposeBag()
    private let reviewCellIdentifier = Strings.Cell.review
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindReviews()
        viewModel.getReviews()
       
    }
   
    
    //MARK: - UI
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .always
        title = Strings.Title.reviews
        reviewsCollection
            .rx
            .setDelegate(self)
            .disposed(by: bag)
    }
    
    //MARK: - UILogic
    private func bindReviews() {
        print("bining....")
        viewModel
            .movieReviews
            .drive(reviewsCollection.rx.items(cellIdentifier: reviewCellIdentifier,
                                                 cellType: ReviewCell.self)) { (row , item , cell) in
                cell.config(name: item.author, content: item.review)
            }
                                                 .disposed(by: bag)
    }
}


extension ReviewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width:  collectionView.bounds.size.width ,
               height: collectionView.bounds.size.height)
    }
}
