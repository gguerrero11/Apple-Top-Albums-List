//
//  Extensions.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    /// Returns a collection of constraints to anchor the bounds of the current view to the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(boundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }
    
    func constraintsForAnchoringTo(safeAreaLayoutBoundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
    }
    
    func constraintsForHeight(height: CGFloat) -> [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(equalToConstant: height)
        ]
    }
}

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIImageView {
    func setImageURL(string: String?) {
        self.backgroundColor = .lightGray
        self.image = UIImage(systemName: "photo")?.withTintColor(.white)
        self.contentMode = .center
        guard let string = string else { return }
        guard let url = URL(string: string) else { return }
        
        var resultImage: UIImage?
        
        DispatchQueue.global().async { [weak self] in
            // if image is in cache set the image
            if let image = AlbumManager.getImage(forPath: string) {
                resultImage = image
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                // otherwise get downloaded image
                AlbumManager.cacheImage(image: image, forPath: string)
                resultImage = image
            }
            
            DispatchQueue.main.async {
                self?.image = resultImage
                self?.contentMode = .scaleAspectFit
                self?.backgroundColor = .clear
            }
        }
    }
}
