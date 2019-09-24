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
  var imageULR: String
  
  private enum CodingKeys: String, CodingKey {
    case name
    case dateofRemoval
    case filePath
    case introduction
    case actors
    case screens
    case modID
    case url
    case imageULR
  }
  
  var description: String {
    return "\n片名： \(name)\n下片日期： \(dateofRemoval)\n簡介： \(introduction)\n演員： \(actors)\n多螢： \(screens)\nID： \(modID)\n連結： \(url)\n圖片： \(imageULR)"
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
