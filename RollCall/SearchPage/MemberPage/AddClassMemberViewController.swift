//
//  AddClassMemberViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/9.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class AddClassMemberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textNum: UITextField!
    @IBOutlet weak var textName: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textNum.delegate = self
        textName.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textNum {
            textName.becomeFirstResponder()
        }else if textField == textName {
            textField.resignFirstResponder()
        }
        return true
    }

    @IBAction func addOneMember(_ sender: Any) {
        let num = Int32(textNum.text!)
        print(num)
        
        // 名字不为空
        if textName.text == "" {
            TipsSwift.showCenterWithText("名字不能为空")
            return
        }
        // 学号不为空
        if textNum.text == "" {
            TipsSwift.showCenterWithText("学号不能为空")
            return
        }

        
        let indexClass = 0
        let oneClassData = arrClassData[indexClass]

        
        // 修改 成员名字
        
        
        // 用json格式保存 课程类别
        let arrMember = ["英语","数学","语文"]
        let memberData = try! JSONSerialization.data(withJSONObject: arrMember, options: .prettyPrinted)
        let strMemberJson:String = String(data: memberData, encoding: String.Encoding.utf8)!
        oneClassData.member = strMemberJson
        
        //        print(strJson)
        
        
        // 数据处理
//        oneClassData.willSave()

//        appDelegate.saveContext()
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    
}
