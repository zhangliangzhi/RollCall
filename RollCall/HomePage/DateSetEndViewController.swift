//
//  DateSetEndViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/13.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class DateSetEndViewController: UIViewController {
    
    @IBOutlet weak var timePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "记录结束时间"
        let strDate:String = arrClassData[gIndexClass].dateEnd!
        let ndate = try! DateInRegion(string: strDate, format: DateFormat.custom("yyyy-MM-dd"))
        timePicker.setDate(ndate.absoluteDate, animated: true)
    }
    
    @IBAction func timeChange(_ sender: Any) {
        // 默认获取的是0时区的日期
        let getDate = timePicker.date
        //        print(getDate)
        let todate = DateInRegion(absoluteDate: getDate)
        //        print(todate)
        arrClassData[gIndexClass].dateEnd = todate.string(format: DateFormat.custom("yyyy-MM-dd"))
        appDelegate.saveContext()
    }
    
}
