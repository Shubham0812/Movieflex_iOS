//
//  CollectionAnimations.swift
//  Movieflex
//
//  Created by Shubham Singh on 18/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

typealias CollectionCellAnimation = (UICollectionViewCell, IndexPath, UICollectionView) -> Void

final class CollectionViewAnimator {
    // TODO- implement hasAnimatedAllCells, so that the animation is applied to cells only once.
    private var hasAnimatedAllCells = false
    private let animation: CollectionCellAnimation
    
    init(animation: @escaping CollectionCellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView) {
        animation(cell, indexPath, collectionView)
    }
}

///enums providing tableViewCell animations
enum CollectionAnimationFactory {
    static func makeFadeAnimation(duration: TimeInterval, delayFactor: TimeInterval) -> CollectionCellAnimation {
        return { cell, indexPath, _ in
            cell.alpha = 0
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
    }
    
    static func makeMoveUpWithFadeAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: TimeInterval) -> CollectionCellAnimation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight * 1.4)
            cell.alpha = 0
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
    }
    
    static func makeMoveUpAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: TimeInterval) -> CollectionCellAnimation {
        return { cell, indexPath, _ in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight * 1.4)
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    static func makeMoveUpBounceAnimation(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CollectionCellAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.6,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
}
