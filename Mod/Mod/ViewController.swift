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
  @IBOutlet weak var tableView: UITableView!
  
  var observer: NSObjectProtocol?
  weak var movieCoordinator: MovieCoordinator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
}
