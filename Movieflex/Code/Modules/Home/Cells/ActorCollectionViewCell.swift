//
//  ActorCollectionViewCell.swift
//  Movieflex
//
//  Created by Shubham Singh on 19/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class ActorCollectionViewCell: UICollectionViewCell, ComponentShimmers {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lineView: LineView!
    @IBOutlet weak var actorImageView: Profile!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var actorMoviesLabel: UILabel!
    
    // MARK:- variables for the cell
    override class func description() -> String {
        return "ActorCollectionViewCell"
    }
    
    let cellHeight: CGFloat = 210
    let displayCellHeight: CGFloat = 185
    let cornerRadius:CGFloat = 8
    let animationDuration: Double = 0.25

    var id : String = ""

    var actorListViewModel: ActorListViewModel?
    var shimmer: ShimmerLayer = ShimmerLayer()
    let buttonAnimationFactory: ButtonAnimationFactory = ButtonAnimationFactory()
    
    var likedConfiguration: ButtonConfiguration  = (symbol: "suit.heart.fill", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default), buttonTint: UIColor.systemPink)
    var normalConfiguation: ButtonConfiguration  = (symbol: "suit.heart", configuration: UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .default), buttonTint: UIColor.tertiaryLabel)
    
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hideViews()
        
        self.containerView.setCornerRadius(radius: cornerRadius)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setButton(with: normalConfiguation)
    }
    
    // MARK:- @objc funcs & IBActions for the viewController
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let actorListViewModel = actorListViewModel else { return }
        let status = actorListViewModel.likePressed(id: id)
        if (status) {
            buttonAnimationFactory.makeActivateAnimation(for: favoriteButton, likedConfiguration)
        } else {
            buttonAnimationFactory.makeDeactivateAnimation(for: favoriteButton, normalConfiguation)
        }
    }
    
    // MARK:- delegate functions for collectionView
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.actorImageView.setOpacity(to: 0)
            self.actorMoviesLabel.setOpacity(to: 0)
            self.favoriteButton.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.actorImageView.setOpacity(to: 1)
            self.actorMoviesLabel.setOpacity(to: 1)
            self.favoriteButton.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            self.lineView.background = Generic.shared.getRandomColor().withAlphaComponent(0.25)
            shimmer.removeLayerIfExists(self)
            shimmer = ShimmerLayer(for: self.containerView, cornerRadius: cornerRadius)
            self.layer.addSublayer(shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    // MARK:- functions for the cell
    func setupCell(viewModel: ActorViewModel?, showFavorites: Bool = true) {
        setShimmer()
    
        guard let viewModel = viewModel else { return }
        if let status = self.actorListViewModel?.checkIfFavorite(id: viewModel.id) {
            if (status) {
                self.setButton(with: likedConfiguration)
            }
        }
        
        if (!showFavorites) {
            self.favoriteButton.isHidden = true
        }
        
        id = viewModel.id
        self.actorNameLabel.text = viewModel.actorName
        self.actorMoviesLabel.text = viewModel.totalMovies
        self.actorImageView.cornerRadius = cornerRadius
        
        DispatchQueue.global().async {
            viewModel.actorImage.bind {
                guard let actorImage = $0 else { return }
                DispatchQueue.main.async { [unowned self] in
                    actorImageView.imageView.image = actorImage
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
