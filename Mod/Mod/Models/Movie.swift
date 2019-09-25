//
//  Movie.swift
//  Mod
//
//  Created by JEROME on 2019/9/23.
//  Copyright © 2019 jerome. All rights reserved.
//

import Foundation

struct Movie: Codable, CustomStringConvertible {
  var name: String
  var dateofRemoval: String
  var filePath: String
  var introduction: String
  var actors: String
  var screens: String
  var modID: Int
  var url: String
  var imageURL: String
  
  private enum CodingKeys: String, CodingKey {
    case name
    case dateofRemoval
    case filePath
    case introduction
    case actors
    case screens
    case modID
    case url
    case imageURL = "imageULR"  // JSON 格式拼寫錯誤
  }
  
  var description: String {
    return "\n片名： \(name)\n下片日期： \(dateofRemoval)\n簡介： \(introduction)\n演員： \(actors)\n多螢： \(screens)\nID： \(modID)\n連結： \(url)\n圖片： \(imageURL)"
  }
  
  //[
  //  {
  //      "name": "神劍闖江湖",
  //      "dateofRemoval": "2019-09-18T16:00:00.000Z",
  //      "filePath": "電影199/動作 電影199/類型/動作",
  //      "introduction": "動盪的幕府末期，各方爭鳴的渾沌年代，千人斬拔刀齋以其萬夫莫敵的飛天御劍流活躍於暗殺界。但隨著新時代的來臨，拔刀齋立下不殺之誓，從此隱姓埋名浪跡天涯……明治11年，一名自稱拔刀齋的男子隨意斬殺路人，造成人心惶惶。繼承了神谷活心流道場的女孩神谷薰，魯莽的挑戰對方，危急之下被自稱緋村劍心的神祕男子所救。小薰留下劍心在道場修練，卻意外發現眼前的落魄浪人，竟是貨真價實的「千人斬拔刀齋」，而假冒拔刀齋之名作惡的，則是受雇於黑心實業家武田觀柳的瘋狂殺手刃衛。",
  //      "actors": "佐藤健,吉川晃司,蒼井優,青木崇高",
  //      "screens": "多螢",
  //      "modID": 588144,
  //      "url": "http://mod.cht.com.tw/video/movie-details.php?id=588144",
  //      "imageULR": "http://mod.cht.com.tw/img/iappic/588144.jpg?id=6"
  //  }
  // ]
}

class MovieLoader {
  static let shared = MovieLoader()
  private let cache = NSCache<NSString, NSData>()
  lazy var requestOperationDictionary = [URL: AsynchronousOperation]()
  
  lazy var queue: OperationQueue = {
    var queue = OperationQueue()
    queue.name = "MovieLoader"
    queue.maxConcurrentOperationCount = 1
    queue.qualityOfService = QualityOfService.userInitiated
    return queue
  }()
  
  func movieDataByURL(completionHandler: @escaping (_ movies: [Movie]) -> Void) {
    let url = URL(string: "https://script.google.com/macros/s/AKfycbyBK1R7As34TQk9Ti7jY8h8l0ctJO9ZMk8MW8ZBfVv4PMJ6BECF/exec")!
    let request = APIRequest(url: url)
    func mainThreadCompletionHandler(movies innerMovies: [Movie]) {
      DispatchQueue.main.async {
        completionHandler(innerMovies)
      }
    }
    let operation = NetworkRequestOperation(request: request) { [weak self] result in
      guard let self = self else {
        assertionFailure()
        return
      }
      guard let operation = self.requestOperationDictionary[url] else {
        mainThreadCompletionHandler(movies: [])
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
          do {
            let movies = try self.parseMovies(data)
            self.cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            mainThreadCompletionHandler(movies: movies)
          } catch {
            logger.log("Movies Data Format Wrong", level: .error)
            mainThreadCompletionHandler(movies: [])
          }
        } else {
          logger.log("No Data", level: .error)
          mainThreadCompletionHandler(movies: [])
        }
        
      case .failure:
        logger.log("failed", level: .error)
        mainThreadCompletionHandler(movies: [])
      }
    }
    requestOperationDictionary[url] = operation
    queue.addOperation(operation)
  }
  
  func parseMovies(_ jsonData: Data) throws -> [Movie] {
    let decoder = JSONDecoder()
    do {
      let movies = try decoder.decode([Movie].self, from: jsonData)
      return movies
    } catch {
      throw error
    }
  }
}
