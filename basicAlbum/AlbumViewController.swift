//
//  AlbumViewController.swift
//  basicAlbum
//
//  Created by Gabe Guerrero on 4/20/20.
//  Copyright © 2020 Gabriel Guerrero. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {
    @UsesAutoLayout
    var tableView = UITableView()
    @UsesAutoLayout
    var navBar = UINavigationBar()
    
    let dequeueCellID = "albumCell"
    let albumManager = AlbumManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        albumManager.albumDownloadCallback = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: dequeueCellID)
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableView.constraintsForAnchoringTo(safeAreaLayoutBoundsOf: view))
    }
    
    func setupNavigationBar() {
        view.addSubview(navBar)
        navBar.barStyle = .default
        NSLayoutConstraint.activate(navBar.constraintsForAnchoringTo(safeAreaLayoutBoundsOf: view))
        NSLayoutConstraint.activate(navBar.constraintsForHeight(height: 60))
    }
}

extension AlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // code to push to detail
    }
}

extension AlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumManager.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: dequeueCellID) as? AlbumTableViewCell {
            let album = albumManager.albums[indexPath.row]

        }
        return UITableViewCell()
    }
}
