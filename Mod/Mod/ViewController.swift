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
      tableView.prefetchDataSource = self
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
  let imageLoader = ImageLoader.shared
  
  deinit {
    removeSatusBarHeightChangedObserver()
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
  func numberOfSections(in tableView: UITableView) -> Int {
//    logger.log("tableViewnumberOfSections", theOSLog: Log.table, level: .info)
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    logger.log("tableViewnumberOfRowsInSection section: \(section))", theOSLog: Log.table, level: .info)
    return movies.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    logger.log("tableViewcellForRowAt indexPath: \(indexPath))", theOSLog: Log.table, level: .info)
    guard let movieTableViewCell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.className) as? MovieTableViewCell else {
        return UITableViewCell()
    }
    movieTableViewCell.updateUI(by: movies[indexPath.row])
    return movieTableViewCell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    logger.log("tableViewwillDisplaycell indexPath: \(indexPath))", theOSLog: Log.table)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    logger.log("tableViewdidEndDisplaying indexPath: \(indexPath))", theOSLog: Log.table)
  }
  
  // MARK: - scrollview delegate methods
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    logger.log("scrollViewWillBeginDragging", theOSLog: Log.table)
    imageLoader.queue.isSuspended = true
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    logger.log("scrollViewDidEndDecelerating", theOSLog: Log.table)
    loadImagesForOnscreenCells()
    imageLoader.queue.isSuspended = false
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    logger.log("scrollViewDidEndDragging decelerate: \(decelerate)", theOSLog: Log.table)
    if decelerate == false {  // 立即停下
      loadImagesForOnscreenCells()
      imageLoader.queue.isSuspended = false
    }
  }
  
  func loadImagesForOnscreenCells() {
    logger.log("tableView.indexPathsForVisibleRows:\(tableView.indexPathsForVisibleRows)", theOSLog: Log.table, level: .fault)
    if let pathsArray = tableView.indexPathsForVisibleRows {
      tableView.reloadRows(at: pathsArray, with: .fade)
    }
  }
}

extension ViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    logger.log("tableViewprefetchRowsAt indexPaths: \(indexPaths))", theOSLog: Log.table, level: .info)
  }

  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    logger.log("tableViewcancelPrefetchingForRowsAt indexPaths: \(indexPaths))", theOSLog: Log.table, level: .info)
  }
}
