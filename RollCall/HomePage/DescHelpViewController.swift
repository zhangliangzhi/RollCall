//
//  DescHelpViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/15.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class DescHelpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numWc: UITextField!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numWc.delegate = self
        bottomLabel.text = "2018@西瓜点名"
        descLabel.text = "随机公平点名\n 1.随机点名 \n2.公平点名\n\n确保每个人点到的次数是一样多的，这次点到名了，下次就不会随机点到了。可设置随机点名人数误差范围，默认是1人误差。"
        
        if arrClassData.count > 0 {
            numWc.text = String(arrClassData[gIndexClass].wc)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if arrClassData.count > 0 {
            var getWc:String = numWc.text!
            getWc = getWc.trimmingCharacters(in: .whitespaces)
            
            // 名字不为空
            if getWc == "" {
                numWc.text = String(arrClassData[gIndexClass].wc)
                return false
            }
            let iWc = Int32(numWc.text!)
            if iWc == nil || iWc! <= 0 {
                numWc.text = String(arrClassData[gIndexClass].wc)
                return false
            }
            
            arrClassData[gIndexClass].wc = iWc!
            appDelegate.saveContext()
        }else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        
        TipsSwift.showCenterWithText("设置成功!")
        return true
    }

}
