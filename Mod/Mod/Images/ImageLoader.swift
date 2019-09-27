// ImageLoader.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh on 2019/9/18.

import UIKit

class SypQueue: OperationQueue {
  
  var networkOperationFiredCounter = 0 {
    didSet {
      logger.log("networkOperationFiredCounter: \(networkOperationFiredCounter)", theOSLog: Log.image)
    }
  }
  
  override func addOperation(_ op: Operation) {
    if op is NetworkRequestOperation {
      networkOperationFiredCounter += 1
    }
    super.addOperation(op)
  }
}

class ImageLoader: NSObject {
  static let shared = ImageLoader()
  private let imageCache = NSCache<NSString, UIImage>()
  lazy var requestOperationDictionary = [URL: AsynchronousOperation]()
  var current: UInt = 0
  
  func synchronized(_ lock: AnyObject, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
  }
  
  func next() -> UInt {
    synchronized(self) {
      current += 1
    }
    return current
  }
  
  lazy var queue: SypQueue = {
    var queue = SypQueue()
    queue.name = "ImageLoader"
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = QualityOfService.userInitiated
    queue.addObserver(self, forKeyPath: "operationCount", options: .new, context: nil)
    return queue
  }()

  func imageByURL(_ url: URL, completionHandler: @escaping (_ image: UIImage?, _ url: URL) -> Void) {
    // get image from cache
    if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
      completionHandler(imageFromCache, url)
      return
    } else {
      let request = APIRequest(url: url)
      func mainThreadCompletionHandler(image innerImage: UIImage?, _ url: URL) {
        DispatchQueue.main.async {
          completionHandler(innerImage, url)
        }
      }
      let operation = NetworkRequestOperation(request: request) { [weak self] result in
        guard let self = self else {
          assertionFailure()
          return
        }
        guard let operation = self.requestOperationDictionary[url] else {
          mainThreadCompletionHandler(image: nil, url)
          return
        }
        defer {
          self.requestOperationDictionary.removeValue(forKey: url)
        }
        guard operation.isCancelled == false else {
          // 取消的話就不執行 CompletionHandler
          for dependenceOp in operation.dependencies {
            operation.removeDependency(dependenceOp)
          }
          return
        }

        switch result {
        case let .success(response):
          if let data = response.body {
            if let image = UIImage(data: data) {
              self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
              mainThreadCompletionHandler(image: image, url)
            } else {
              logger.log("Data Format Wrong", theOSLog: Log.image, level: .error)
              mainThreadCompletionHandler(image: nil, url)
            }
          } else {
            logger.log("No Data", theOSLog: Log.image, level: .error)
            mainThreadCompletionHandler(image: nil, url)
          }

        case let .failure(error):
          logger.log(error.localizedDescription, theOSLog: Log.image, level: .error)
          mainThreadCompletionHandler(image: nil, url)
        }
      }
      requestOperationDictionary[url] = operation
      queue.addOperation(operation)
    }
  }

  func cancelRequest(url: URL) {
    if let operation = requestOperationDictionary[url] {
      if operation.isExecuting == false {
        requestOperationDictionary.removeValue(forKey: url)
        operation.cancel()
      }
    }
  }
}

// MARK: - KVO

extension ImageLoader {
  override func observeValue(forKeyPath _: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
    logger.log("operationCount: \(queue.operationCount)", theOSLog: Log.image)
  }
}
