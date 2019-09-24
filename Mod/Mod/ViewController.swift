// ViewController.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh on 2019/9/18.

import UIKit

class ViewController: UIViewController, Storyboarded, HasJeromeNavigationBar {
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var statusView: UIView!
  @IBOutlet weak var navagationView: UIView!
  @IBOutlet weak var statusViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var navagationViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var titleLabel: UILabel! {
    didSet {
      titleLabel.text = "電影199"
    }
  }
  @IBOutlet weak var searchBarView: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView! {
    didSet {
      tableView.dataSource = self
      tableView.delegate = self
    }
  }
  
  var observer: NSObjectProtocol?
  weak var movieCoordinator: MovieCoordinator?
  let movieLoader = MovieLoader.shared
  var movies = [Movie]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    movieLoader.movieDataByURL { [weak self] movies in
      guard let self = self else { return }
      guard movies.isEmpty == false else { return }
      self.movies = movies
    }
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.className) else {
        return UITableViewCell()
    }
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let movieTableViewCell = cell as? MovieTableViewCell else {
      assertionFailure()
      return
    }
    movieTableViewCell.updateUI(by: movies[indexPath.row])
  }
}
