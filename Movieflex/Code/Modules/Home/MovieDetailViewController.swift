//
//  MovieDetailViewController.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    // MARK:- variables for the viewController
    override class func description() -> String {
        "MovieDetailViewController"
    }
    
    var viewModel: MovieViewModel?
    var detailViewModel: MovieDetailViewModel?
    var actorListViewModel: ActorListViewModel?
    
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = self.viewModel else { return }
        viewModel.moviePosterImage.bind {
            guard let posterImage = $0 else { return }
            DispatchQueue.main.async { [unowned self] in
                moviePosterImageView.image = posterImage
            }
        }
        
        self.detailViewModel = MovieDetailViewModel(movieId: viewModel.id)
        self.actorListViewModel = ActorListViewModel(movieId: viewModel.id)
        
        self.detailViewModel?.movieDetails.bind {
            guard let movieDetail = $0 else { return }
            print(movieDetail)
        }

        self.setupView()
    }
    
    // MARK:- objc & outlet functions for the viewController
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- functions for the viewController
    
    // MARK:- utility functions for the viewController
    func setupView() {
        self.backButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        self.backButton.setCornerRadius(radius: self.backButton.frame.width / 2)
        
        self.favoriteButton.backgroundColor = UIColor.label.withAlphaComponent(0.75)
        self.favoriteButton.setCornerRadius(radius: self.favoriteButton.frame.width / 2 - 2)
        
        self.moviePosterImageView.setCornerRadius(radius: 16)
        self.movieTitleLabel.text = viewModel?.movieTitle
    }
}


extension MovieDetailViewController {
    
}
