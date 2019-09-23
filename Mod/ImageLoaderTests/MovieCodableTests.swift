//
//  MovieCodableTests.swift
//  ImageLoaderTests
//
//  Created by JEROME on 2019/9/23.
//  Copyright © 2019 jerome. All rights reserved.
//

import XCTest

class MovieCodableTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
      let json = """
  [
    {
        "name": "神劍闖江湖",
        "dateofRemoval": "2019-09-18T16:00:00.000Z",
        "filePath": "電影199/動作 電影199/類型/動作",
        "introduction": "動盪的幕府末期，各方爭鳴的渾沌年代，千人斬拔刀齋以其萬夫莫敵的飛天御劍流活躍於暗殺界。但隨著新時代的來臨，拔刀齋立下不殺之誓，從此隱姓埋名浪跡天涯……明治11年，一名自稱拔刀齋的男子隨意斬殺路人，造成人心惶惶。繼承了神谷活心流道場的女孩神谷薰，魯莽的挑戰對方，危急之下被自稱緋村劍心的神祕男子所救。小薰留下劍心在道場修練，卻意外發現眼前的落魄浪人，竟是貨真價實的「千人斬拔刀齋」，而假冒拔刀齋之名作惡的，則是受雇於黑心實業家武田觀柳的瘋狂殺手刃衛。",
        "actors": "佐藤健,吉川晃司,蒼井優,青木崇高",
        "screens": "多螢",
        "modID": 588144,
        "url": "http://mod.cht.com.tw/video/movie-details.php?id=588144",
        "imageULR": "http://mod.cht.com.tw/img/iappic/588144.jpg?id=6"
    },
    {
        "name": "記憶解碼戰",
        "dateofRemoval": "2019-09-18T16:00:00.000Z",
        "filePath": "電影199/動作 電影199/類型/動作",
        "introduction": "美麗少女喬安娜在軍火製造廠父親一次武器展示中，意外大腦受損導致認知障礙，為此父親深感內疚而終止此先進武器的研發，並暗中將此先進武器公式密碼封鎖在喬安娜大腦中，因而一場針對喬安娜大腦驚心設計秘密計劃暗中險惡展開，先進武器密碼能否從喬安娜大腦中解碼？而喬安娜的生命又將遭遇何種浩劫？",
        "actors": "愛德華多諾列加,芭芭拉葛娜嘉,菲力高梅斯,瑪蒂娜吉黛克",
        "screens": "多螢",
        "modID": 578030,
        "url": "http://mod.cht.com.tw/video/movie-details.php?id=578030",
        "imageULR": "http://mod.cht.com.tw/img/iappic/578030.jpg?id=100"
    }
  ]
""".data(using: .utf8)!
      let decoder = JSONDecoder()
      do {
        let movies = try decoder.decode([Movie].self, from: json)
        logger.log("The following movies are available:")
        for movie in movies {
          logger.log("\(movie.name) \(movie.dateofRemoval)", theOSLog: Log.test, level: .defaultLevel)
        }
      } catch {
        XCTFail()
      }
      
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
