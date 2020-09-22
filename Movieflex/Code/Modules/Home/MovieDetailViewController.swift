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
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var movieFansLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var actorCollectionView: UICollectionView!
    
    // MARK:- variables for the viewController
    override class func description() -> String {
        "MovieDetailViewController"
    }
    
    let defaultsManager = UserDefaultsManager()
    let networkManager = NetworkManager()
    let fileHandler = FileHandler()
    
    var viewModel: MovieViewModel!
    var movieListViewModel: MovieListViewModel?
    
    var detailViewModel: MovieDetailViewModel!
    var actorListViewModel: ActorListViewModel!
    
    var likedConfiguration: ButtonConfiguration  = (symbol: "suit.heart.fill", configuration: UIImage.SymbolConfiguration(pointSize: 31, weight: .semibold, scale: .default), buttonTint: UIColor.systemPink)
    var normalConfiguation: ButtonConfiguration  = (symbol: "suit.heart", configuration: UIImage.SymbolConfiguration(pointSize: 31, weight: .semibold, scale: .default), buttonTint: UIColor.tertiaryLabel)
    let buttonAnimationFactory: ButtonAnimationFactory = ButtonAnimationFactory()
    
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // comingSoon
        self.actorCollectionView.delegate = self
        self.actorCollectionView.dataSource = self
        self.actorCollectionView.register(ActorCollectionViewCell().asNib(), forCellWithReuseIdentifier: ActorCollectionViewCell.description())
        
        guard let viewModel = self.viewModel else { return }
        viewModel.moviePosterImage.bind {
            guard let posterImage = $0 else { return }
            DispatchQueue.main.async { [unowned self] in
                moviePosterImageView.image = posterImage
            }
        }
        
        self.movieRuntimeLabel.text = viewModel.movieRunTime
        self.movieFansLabel.text = viewModel.movieFans
        self.movieRatingLabel.text = viewModel.movieRating
        
        
        self.detailViewModel = MovieDetailViewModel(movieId: viewModel.id, handler: fileHandler, networkManager: networkManager, defaultsManager: defaultsManager)
        self.actorListViewModel = ActorListViewModel(movieId: viewModel.id, handler: fileHandler, networkManager: networkManager, defaultsManager: defaultsManager)
        
        self.actorListViewModel.actorsForMovie.bind { _ in
            self.actorCollectionView.reloadData()
        }
        self.detailViewModel.moviePlot.bind {
            guard let moviePlot = $0 else { return }
            self.movieDescriptionLabel.text = moviePlot
        }
        
        self.setupView()
    }
    
    // MARK:- objc & outlet functions for the viewController
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        guard let viewModel = viewModel, let detailViewModel = detailViewModel, let movieListViewModel = movieListViewModel else { return }
        let status = detailViewModel.likePressed(id: viewModel.id)
        movieListViewModel.getFavorites()
        
        if (status) {
            buttonAnimationFactory.makeActivateAnimation(for: favoriteButton, likedConfiguration)
        } else {
            buttonAnimationFactory.makeDeactivateAnimation(for: favoriteButton, normalConfiguation)
        }
    }
    
    // MARK:- utility functions for the viewController
    func setupView() {
        self.backButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.95)
        self.backButton.setCornerRadius(radius: self.backButton.frame.width / 2)
        
        self.favoriteButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
        self.favoriteButton.setCornerRadius(radius: self.favoriteButton.frame.width / 2 - 2)
        
        self.moviePosterImageView.setCornerRadius(radius: 16)
        self.movieTitleLabel.text = viewModel?.movieTitle
        
        if let status = self.detailViewModel?.checkIfFavorite(id: viewModel.id) {
            if (status) {
                self.setButton(with: likedConfiguration)
            }
        }
    }
    
    func setButton(with config: ButtonConfiguration) {
        self.favoriteButton.setImage(UIImage(systemName: config.symbol, withConfiguration: config.configuration), for: .normal)
        self.favoriteButton.tintColor = config.buttonTint
    }
}


extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.actorListViewModel.getCountForDisplay(type: .actorsForMovie)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let actorViewModels =  actorListViewModel.actorsForMovie.value else { return UICollectionViewCell() }
        return self.actorListViewModel.prepareCellForDisplay(collectionView: collectionView, indexPath: indexPath, actorViewModel: actorViewModels[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.getSizeForHorizontalCollectionView(columns: 2.5, height: ActorCollectionViewCell().cellHeight)
    }
}
