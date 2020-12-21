//
//  MovieSearchViewCell.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class MovieSearchViewCell: UITableViewCell, ComponentShimmers {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    @IBOutlet weak var detailStackView: UIStackView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    // MARK:- variables for the cell
    override class func description() -> String {
        return "MovieSearchViewCell"
    }
    
    
    let animationDuration: Double = 0.25
    let cornerRadius: CGFloat = 12
    let rowHeight: CGFloat = 200
    
    var shimmer: ShimmerLayer = ShimmerLayer()
    var searchViewModel: MovieSearchViewModel?
    
    var id : String = ""
    
    var likedConfiguration: ButtonConfiguration  = (symbol: "suit.heart.fill", configuration: UIImage.SymbolConfiguration(pointSize: 27, weight: .medium, scale: .default), buttonTint: UIColor.systemPink)
    var normalConfiguation: ButtonConfiguration  = (symbol: "suit.heart", configuration: UIImage.SymbolConfiguration(pointSize: 27, weight: .medium, scale: .default), buttonTint: UIColor.tertiaryLabel)
    let buttonAnimationFactory: ButtonAnimationFactory = ButtonAnimationFactory()
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        hideViews()
        
        self.moviePosterImageView.setCornerRadius(radius: cornerRadius - 4)
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.containerView.setShadow(shadowColor: UIColor.label, shadowOpacity: 0.25, shadowRadius: 10, offset: CGSize(width: 1, height: 1))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.containerView.setShadow(shadowColor: UIColor.label, shadowOpacity: 0.25, shadowRadius: 10, offset: CGSize(width: 1, height: 1))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideViews()
        self.setButton(with: normalConfiguation)
    }
    
    // MARK:- @objc funcs & IBActions for the viewController
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let searchViewModel = searchViewModel else { return }
        let status = searchViewModel.likePressed(id: id)
        if (status) {
            buttonAnimationFactory.makeActivateAnimation(for: favoriteButton, likedConfiguration)
        } else {
            buttonAnimationFactory.makeDeactivateAnimation(for: favoriteButton, normalConfiguation)
        }
    }
    
    // MARK:- delegate functions for collectionView
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.moviePosterImageView.setOpacity(to: 0)
            self.movieTitleLabel.setOpacity(to: 0)
            self.detailStackView.setOpacity(to: 0)
            self.favoriteButton.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.moviePosterImageView.setOpacity(to: 1)
            self.movieTitleLabel.setOpacity(to: 1)
            self.detailStackView.setOpacity(to: 1)
            self.favoriteButton.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            self.shimmer.removeLayerIfExists(self)
            self.shimmer = ShimmerLayer(for: self.containerView, cornerRadius: 12)
            self.layer.addSublayer(self.shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    
    // MARK:- functions for the cell
    func setupCell(viewModel: MovieViewModel) {
        setShimmer()
        if let status = self.searchViewModel?.checkIfFavorite(id: viewModel.id) {
            if (status) {
                self.setButton(with: likedConfiguration)
            }
        }
        
        self.movieTitleLabel.text = viewModel.movieTitle
        self.movieRuntimeLabel.text = viewModel.movieRunTime
        self.movieReleaseLabel.text = viewModel.releaseDate
        self.ratingLabel.text = viewModel.movieRating
        
        DispatchQueue.global().async {
            viewModel.moviePosterImagePath.bind {
                guard let posterImage = $0 else { return }
                self.id = viewModel.id
                DispatchQueue.main.async { [unowned self] in
                    let downsampledImage = Downsampler.downsampleImage(imageURL: posterImage, frameSize: self.moviePosterImageView.bounds.size)
                    self.moviePosterImageView.image = downsampledImage
                    self.removeShimmer()
                    self.showViews()
                }
            }
        }
    }
    
    func setButton(with config: ButtonConfiguration) {
        self.favoriteButton.setImage(UIImage(systemName: config.symbol, withConfiguration: config.configuration), for: .normal)
        self.favoriteButton.tintColor = config.buttonTint
    }
}
