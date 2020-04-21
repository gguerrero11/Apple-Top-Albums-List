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
    
    /// Returns a collection of constraints to anchor the bounds of the current view to safe are layout bounds of the given view.
    ///
    /// - Parameter view: The view to anchor to.
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(safeAreaLayoutBoundsOf view: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ]
    }
    
    /// Returns a collection of constraints to anchor the bounds of the current view to safe are layout bounds of the given view with padding
    ///
    /// - Parameter view: The view to anchor to.
    /// - Parameter padding: The amount of padding from the edges
    /// - Returns: The layout constraints needed for this constraint.
    func constraintsForAnchoringTo(safeAreaLayoutBoundsOf view: UIView, padding: CGFloat) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: padding),
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
    /// Sets the imageView's image property with an image from a URL. Temporarily stores sets the image to a
    /// system icon as a placeholder. It checks if the image has been pre-cached, if not it will download it and save it to the cache
    ///
    /// - Parameter string: The string URL of the image
    func setImageURL(string: String?) {
        self.backgroundColor = .lightGray
        self.image = UIImage(systemName: "photo")?.withTintColor(.white)
        self.contentMode = .center
        guard let string = string else { return }
        guard let url = URL(string: string) else { return }
        
        var resultImage: UIImage?
        
        DispatchQueue.global().async { [weak self] in
            // if image is in cache set the image
            if let image = AlbumManager.getImage(forKey: string) {
                resultImage = image
            } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                // otherwise get downloaded image
                AlbumManager.cacheImage(image: image, forKey: string)
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

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd")-> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {

    func toString(withFormat format: String = "MMMM d, yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
