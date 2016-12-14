//
//  DescHelpViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/15.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class DescHelpViewController: UIViewController {

    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomLabel.text = "2016@张良志 客服:521401@qq.com"
        descLabel.text = "随机公平点名\n 两个功能：1.随机点名 2.公平点名\n确保每个人点到的次数是一样多的，这次点到名了，下次就不会随机点到了。"
    }



}
