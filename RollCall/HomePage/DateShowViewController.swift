//
//  DataShowViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/12.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class DataShowViewController: UIViewController {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    var dateStart:String = ""
    var dateEnd:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startLabel.text = arrClassData[gIndexClass].dateStart
        endLabel.text = arrClassData[gIndexClass].dateEnd
    }
    
    // 设置截止日期
    @IBAction func setEndTime(_ sender: Any) {
        
    }
    
    // 设置开始日期
    @IBAction func setStartTime(_ sender: Any) {
        
    }

}
