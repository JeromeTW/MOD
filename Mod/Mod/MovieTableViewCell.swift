//
//  MovieTableViewCell.swift
//  Mod
//
//  Created by JEROME on 2019/9/24.
//  Copyright © 2019 jerome. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  static let defaultImage = UIColor.lightGray.image()
  
  @IBOutlet weak var movieNameLabel: UILabel!
  @IBOutlet weak var movieThumbnailImageView: UIImageView!
  @IBOutlet weak var introdutionLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  var taskID: UInt?
  
  let imageLoader = ImageLoader.shared
  
  func reset() {
    movieNameLabel.text = ""
    introdutionLabel.text = ""
    movieThumbnailImageView.contentMode = .scaleToFill
    movieThumbnailImageView.image = MovieTableViewCell.defaultImage
    activityIndicator.startAnimating()
    taskID = nil
  }
  
  func updateUI(by movie: Movie) {
    movieNameLabel.text = movie.name
    introdutionLabel.text = movie.introduction
    guard imageLoader.queue.isSuspended == false else {
      logger.log("queue.isSuspended == true")
      return
    }
    if let url = URL(string: movie.imageURL) {
      let issuedIdentifier = imageLoader.next()
      taskID = issuedIdentifier
      imageLoader.imageByURL(url) { [weak self] (image, url) in
        guard let self = self else { return }
        if let image = image, issuedIdentifier == self.taskID {
          self.taskID = nil
          self.activityIndicator.stopAnimating()
          self.movieThumbnailImageView.image = image
        }
      }
    }
  }
}
