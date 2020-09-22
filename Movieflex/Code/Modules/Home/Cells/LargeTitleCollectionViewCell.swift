//
//  LargeTitleCollectionViewCell.swift
//  Movieflex
//
//  Created by Shubham Singh on 18/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class LargeTitleCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieReleaseLabel: UILabel!
    
    // MARK:- variables for the cell
    override class func description() -> String {
        return "LargeTitleCollectionViewCell"
    }
    
    let animationDuration: Double = 0.25
    let cellHeight: CGFloat = 240
    let cornerRadius:CGFloat = 8
    
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.setCornerRadius(radius: cornerRadius)
        self.moviePosterImageView.setCornerRadius(radius: cornerRadius)
        self.moviePosterImageView.setShadow(shadowColor: UIColor.label, shadowOpacity: 1, shadowRadius: 10, offset: CGSize(width: 0, height: 2))
        self.moviePosterImageView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }
    
    // MARK:- delegate functions for collectionView
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.moviePosterImageView.setOpacity(to: 0)
            self.movieTitleLabel.setOpacity(to: 0)
            self.movieGenreLabel.setOpacity(to: 0)
            self.movieReleaseLabel.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.moviePosterImageView.setOpacity(to: 1)
            self.movieTitleLabel.setOpacity(to: 1)
            self.movieGenreLabel.setOpacity(to: 1)
            self.movieReleaseLabel.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: self.moviePosterImageView, cornerRadius: 12)
            self.layer.addSublayer(shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    // MARK:- functions for the cell
    func setupCell(viewModel: MovieViewModel?) {
        setShimmer()
        guard let viewModel = viewModel else { return }
        self.movieTitleLabel.text = viewModel.movieTitle
        self.movieGenreLabel.text = viewModel.movieGenres
        self.movieReleaseLabel.text = viewModel.releaseDate
        
        DispatchQueue.global().async {
            viewModel.moviePosterImage.bind {
                guard let posterImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    moviePosterImageView.image = posterImage
                    removeShimmer()
                    showViews()
                }
            }
        }
    }
}
