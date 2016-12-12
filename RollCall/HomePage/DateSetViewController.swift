//
//  DateSetViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/12.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class DateSetViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func timeChange(_ sender: Any) {
        let data = timePicker.date
        print(data)
    }

}
