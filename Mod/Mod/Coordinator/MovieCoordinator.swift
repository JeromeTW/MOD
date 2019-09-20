//
//  VideoCoordinator.swift
//  JeromeYoutube
//
//  Created by JEROME on 2019/9/18.
//  Copyright © 2019 jerome. All rights reserved.
//

import UIKit

class MovieCoordinator: Coordinator {
  var navigationController: CoordinatedNavigationController
  // TODO: use your storyboard
  let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
  
  init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
    self.navigationController = navigationController
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.coordinator = self

    let vc = ViewController.instantiate(storyboard: storyboard)
    vc.movieCoordinator = self
    navigationController.navigationBar.isHidden = true
    navigationController.viewControllers = [vc]
  }
  
  // Use Coordinator change page sample.
//  func videoCategoryDetail(category: VideoCategory) {
//    let categoryDetailVC = CategoryDetailVC.instantiate(storyboard: storyboard)
//    categoryDetailVC.category = category
//    categoryDetailVC.videoCoordinator = self
//    navigationController.pushViewController(categoryDetailVC, animated: true)
//  }
}
