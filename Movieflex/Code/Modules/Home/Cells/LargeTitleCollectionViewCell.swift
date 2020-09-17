//
//  LargeTitleCollectionViewCell.swift
//  Movieflex
//
//  Created by Shubham on 16/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class LargeTitleCollectionViewCell: UICollectionViewCell {
    
    // MARK:- outlets for the cell
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    
    
    // MARK:- variables for the cell
    override class func description() -> String {
        return "LargeTitleCollectionViewCell"
    }
    
    let dissolveDuration: TimeInterval = 0.2
    let cellHeight: CGFloat = 240
    
    
    // MARK:- lifeCycle methods for the cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.setCornerRadius(radius: 12)
        self.moviePosterImageView.setCornerRadius(radius: 12)
        self.moviePosterImageView.setShadow(shadowColor: UIColor.label, shadowOpacity: 1, shadowRadius: 10, offset: CGSize(width: 0, height: 2))
        self.moviePosterImageView.setBorder(with: UIColor.label.withAlphaComponent(0.15), 2)
    }
    
    func setupCell(viewModel: MovieViewModel) {
        self.movieTitleLabel.text = viewModel.movieTitle
        self.movieGenreLabel.text = viewModel.movieGenres
        
        self.moviePosterImageView.af_setImage(withURL: viewModel.moviePosterUrl, placeholderImage: UIImage(named: "batman"), progressQueue: DispatchQueue.global(qos: .userInteractive), imageTransition: .crossDissolve(dissolveDuration)) { res in
            
        
            print(res, res.data )
        }
    }
}
