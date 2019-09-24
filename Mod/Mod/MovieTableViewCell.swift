//
//  MovieTableViewCell.swift
//  Mod
//
//  Created by JEROME on 2019/9/24.
//  Copyright © 2019 jerome. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  @IBOutlet weak var movieNameLabel: UILabel!
  @IBOutlet weak var movieThumbnailImageView: UIImageView!
  @IBOutlet weak var introdutionLabel: UILabel!
  let imageLoader = ImageLoader.shared
  func updateUI(by movie: Movie) {
    movieNameLabel.text = movie.name
    introdutionLabel.text = movie.introduction
    if let url = URL(string: movie.imageURL) {
      imageLoader.imageByURL(url) { [weak self] (image, url) in
        guard let self = self else { return }
        if let image = image {
          self.movieThumbnailImageView.image = image
        }
      }
    }
  }
  // TODO: Cancel
}
