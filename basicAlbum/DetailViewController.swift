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
    let padding: CGFloat = 20
    let edgePadding: CGFloat = 20.0
    @UsesAutoLayout var stackView = UIStackView()
    @UsesAutoLayout var imageView = UIImageView()
    @UsesAutoLayout var button = UIButton()
    @UsesAutoLayout var container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        setupiTunesLink()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
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
    
    func setupiTunesLink() {
        let container = UIView()
        container.addSubview(button)
        button.setTitle("iTunes Store", for: .normal)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(DetailViewController.openArtistPage), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 25
        stackView.addArrangedSubview(container)
        
        let constraints = [
            button.topAnchor.constraint(equalTo: container.topAnchor),
            button.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            button.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            button.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: CGFloat(50)),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func openArtistPage() {
        if let stringUrl = album?.artistUrl, let url = URL(string: stringUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let msg = UIAlertController(title: "Missing Artist URL", message: "Artist doesn't not have an iTunes store page", preferredStyle: .alert)
            present(msg, animated: true, completion: nil)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.album = nil
    }
    
}

/// A pre-arranged view that with the title category and value for the category
class DetailEntryView: UIView {
    @UsesAutoLayout var titleLabel = UILabel()
    @UsesAutoLayout var valueLabel = UILabel()
    @UsesAutoLayout var stackView = UIStackView()
    @UsesAutoLayout var container = UIView()
    
    var title: String = "Title"
    var value: String = "Not available"

    init(title: String, value: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.title = title
        self.value = value ?? "Not available"
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        container.addSubview(titleLabel)
        addSubview(container)
        addSubview(valueLabel)
        setupTitleLabel()
        setupValueLabel()
    }
        
    func setupTitleLabel() {
        titleLabel.text = title
        titleLabel.textAlignment = .right
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .lightGray
        titleLabel.sizeToFit()
        titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        
        let constraints = [
            container.widthAnchor.constraint(equalToConstant: 50),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            container.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupValueLabel() {
        valueLabel.text = value
        valueLabel.textAlignment = .left
        valueLabel.textColor = .black
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        valueLabel.numberOfLines = 0
        valueLabel.sizeToFit()
        
        let constraints = [
            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: container.trailingAnchor, constant: 10),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 20),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

