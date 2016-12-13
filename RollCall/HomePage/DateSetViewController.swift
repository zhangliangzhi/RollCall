//
//  DateSetViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/12.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import SwiftDate

class DateSetViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func timeChange(_ sender: Any) {
        // 默认获取的是0时区的日期
        let getDate = timePicker.date
//        print(getDate)
        let todate = DateInRegion(absoluteDate: getDate)
//        print(todate)
        arrClassData[gIndexClass].dateStart = todate.string(format: DateFormat.custom("yyyy-MM-dd"))
        appDelegate.saveContext()
    }

}
