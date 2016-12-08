//
//  AddClassNameViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/8.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class AddClassNameViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    @IBAction func addClassName(_ sender: Any) {
        // 班级名字不为空
        if textField.text == "" {
            TipsSwift.showCenterWithText("班级名字不能为空")
            return
        }
        
        // 加入一个班级名字
        let oneClassData = ClassData(context: contextData)
        oneClassData.classname = textField.text
        oneClassData.sortID = Int64(Date().timeIntervalSince1970 * 10000)
        

        
        contextData.insert(oneClassData)
        appDelegate.saveContext()
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    




}
