//
//  DetailViewController.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var album: Album?
    let padding: CGFloat = 15.0
    let edgePadding: CGFloat = 20.0
    @UsesAutoLayout var stackView = UIStackView()
    @UsesAutoLayout var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        setupViews()
    }
    
    init(withAlbum: Album) {
        super.init(nibName: nil, bundle: nil)
        self.album = withAlbum
        title = album?.name
    }
    
    func setupViews() {
        setupStackView()
        setupAlbumImage(url: album?.imageURL)
        setupCopyright(string: album?.copyright ?? "")
        stackView.addArrangedSubview(DetailEntryView(title: "ALBUM", value: album?.name))
        stackView.addArrangedSubview(DetailEntryView(title: "ARTIST", value: album?.artistName))
        stackView.addArrangedSubview(DetailEntryView(title: "RELEASE DATE", value: album?.releaseDate?.toDate()?.toString()))
        setupGenres()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = padding
        view.addSubview(stackView)
        NSLayoutConstraint.activate(stackView.constraintsForAnchoringTo(safeAreaLayoutBoundsOf: view, padding: padding))
    }
        
    func setupAlbumImage(url: String?) {
        let container = UIView()
        container.addSubview(imageView)
        stackView.addArrangedSubview(container)
        imageView.setImageURL(string: url)
        
        let constraints = [
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            container.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ]
    
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupCopyright(string: String) {
        let label = UILabel()
        label.text = string
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 8, weight: .light)
        label.numberOfLines = 0
        label.textColor = .lightGray
        stackView.addArrangedSubview(label)
    }
    
    func setupGenres() {
        var result = ""
        if let genres = album?.genres {
            for (index, genre) in genres.enumerated() {
                guard let genreName = genre.name else { continue }
                result += genreName
                if index != genres.endIndex-1 { result += ", " }
            }
        }

        stackView.addArrangedSubview(DetailEntryView(title: "GENRES", value: result))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.album = nil
    }
    
}

class DetailEntryView: UIView {
    var titleLabel = UILabel()
    var valueLabel = UILabel()
    @UsesAutoLayout var stackView = UIStackView()
    
    var title: String = "Title"
    var value: String = "Not available"

    init(title: String, value: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.title = title
        self.value = value ?? "Not available"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        setupStackView()
        setupTitleLabel()
        setupValueLabel()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.alignment = .top
        stackView.distribution = .fillProportionally
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        NSLayoutConstraint.activate(stackView.constraintsForAnchoringTo(boundsOf: self))
    }
    
    func setupTitleLabel() {
        titleLabel.text = title
        titleLabel.textAlignment = .right
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .lightGray
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        NSLayoutConstraint.activate([titleLabel.widthAnchor.constraint(equalToConstant: 80)])
    }
    
    func setupValueLabel() {
        valueLabel.text = value
        valueLabel.textAlignment = .left
        valueLabel.textColor = .black
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        valueLabel.numberOfLines = 0
    }
}

