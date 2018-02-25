//
//  MyColor.swift
//  xxword
//
//  Created by ZhangLiangZhi on 2017/4/23.
//  Copyright © 2017年 xigk. All rights reserved.
//

import Foundation
import UIKit

func randomSmallCaseString(length: Int) -> String {
    var output = ""
    for _ in 0..<length {
        let randomNumber = arc4random() % 26 + 97
        let randomChar = Character(UnicodeScalar(randomNumber)!)
        output.append(randomChar)
    }
    return output
}

// 背景1
let BG1_COLOR = UIColor(red: 233/255, green: 228/255, blue: 217/255, alpha: 1)
let BG_COLOR = UIColor(red: 246/255, green: 246/255, blue: 250/255, alpha: 1)   // 几乎白色

// 背景2
let BG2_COLOR = UIColor(red: 249/255, green: 247/255, blue: 242/255, alpha: 1)

// 淡蓝1
let BG3_COLOR = UIColor(red: 230/255, green: 245/255, blue: 255/255, alpha: 1)
// 淡蓝2
let BG4_COLOR = UIColor(red: 214/255, green: 238/255, blue: 255/255, alpha: 1)
// 蓝, 标题，导航头部
let BLUE_COLOR = UIColor(red: 55/255, green: 124/255, blue: 185/255, alpha: 1)
let BLUE2_COLOR = UIColor(red: 0/255, green: 170/255, blue: 251/255, alpha: 1)

// 金
let GOLD_COLOR = UIColor(red: 222/255, green: 155/255, blue: 1/255, alpha: 1)

let TI_COLOR = UIColor(red: 249/255, green: 247/255, blue: 242/255, alpha: 1)

// 首页文字1 大字
let WZ1_COLOR = UIColor(red: 120/255, green: 105/255, blue: 90/255, alpha: 1)

// 首页文字2 小字
let WZ2_COLOR = UIColor(red: 181/255, green: 172/255, blue: 149/255, alpha: 1)

// 成功颜色
let CG_COLOR = UIColor(red: 102/255, green: 184/255, blue: 77/255, alpha: 1)
let INFO_COLOR = UIColor(red: 99/255, green: 191/255, blue: 225/255, alpha: 1)  // 青色
let DEF_COLOR = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)  // 
let WARN_COLOR = UIColor(red: 238/255, green: 174/255, blue: 56/255, alpha: 1)  // 橙色
let DANG_COLOR = UIColor(red: 212/255, green: 84/255, blue: 76/255, alpha: 1)   // 红色
let PRI_COLOR = UIColor(red: 70/255, green: 138/255, blue: 207/255, alpha: 1)   // 蓝色

// 单词颜色
let WZ4_COLOR = UIColor(red: 150/255, green: 154/255, blue: 153/255, alpha: 1)

let SX1_COLOR = UIColor(red: 218/255, green: 213/255, blue: 203/255, alpha: 1)  // 深背景
let SX2_COLOR = UIColor(red: 233/255, green: 228/255, blue: 217/255, alpha: 1)  // 浅背景
let SX3_COLOR = UIColor(red: 74/255, green: 85/255, blue: 105/255, alpha: 1)    // 单词颜色
let SX4_COLOR = UIColor(red: 144/255, green: 144/255, blue: 144/255, alpha: 1)  // 音标颜色,灰
let SX5_COLOR = UIColor(red: 181/255, green: 172/255, blue: 150/255, alpha: 1)  // 背景边框的颜色
