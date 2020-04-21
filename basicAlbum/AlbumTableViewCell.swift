//
//  AlbumTableViewCell.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @UsesAutoLayout var albumLabel = UILabel()
    @UsesAutoLayout var artistLabel = UILabel()
    @UsesAutoLayout var artImageView = UIImageView()
    @UsesAutoLayout var stackView = UIStackView()
    @UsesAutoLayout var labelStackView = UIStackView()
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        clipsToBounds = true
        
        setupArtImage()
        setupAlbumLabel()
        setupArtistLabel()
    }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupArtImage() {
        contentView.addSubview(artImageView)
        artImageView.backgroundColor = .lightGray
        artImageView.image = UIImage(systemName: "photo")?.withTintColor(.white)
        artImageView.tintColor = .white
        artImageView.contentMode = .center
        artImageView.layer.cornerRadius = artImageView.frame.height/2
        
        let constraints = [
            artImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            artImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            artImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            artImageView.widthAnchor.constraint(equalTo: artImageView.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupAlbumLabel() {
        contentView.addSubview(albumLabel)
        albumLabel.textAlignment = .natural
        albumLabel.textColor = .darkGray
        albumLabel.numberOfLines = 2
        albumLabel.lineBreakMode = .byTruncatingTail
        albumLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        let constraints = [
            albumLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            albumLabel.leadingAnchor.constraint(equalTo: artImageView.trailingAnchor, constant: 15),
            albumLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupArtistLabel() {
        contentView.addSubview(artistLabel)
        artistLabel.textAlignment = .natural
        artistLabel.textColor = .lightGray
        artistLabel.numberOfLines = 1
        artistLabel.lineBreakMode = .byTruncatingTail
        artistLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        let constraints = [
            artistLabel.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 0),
            artistLabel.leadingAnchor.constraint(equalTo: albumLabel.leadingAnchor, constant: 0),
            artistLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 10),
            artistLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
