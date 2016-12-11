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

    var mIndexClass = 0
    
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


        // 修改 成员名字
        let strOneMem = "{\"id\":\"" + textNum.text! + "\",\"name\":\"" + textName.text! + "\"}"
        
        // 用json格式保存 课程类别
        let oneClassData = arrClassData[mIndexClass]
        let strMembers:String = oneClassData.member!
        
        print(strMembers)
        let indexstr = strMembers.index(strMembers.endIndex, offsetBy: -1)
        let tmpstr1 = strMembers.substring(to: indexstr)
        var strMemberJson:String = ""
        if strMembers == "[]" {
            strMemberJson = tmpstr1 + strOneMem + "]"
        }else{
            strMemberJson = tmpstr1 + "," + strOneMem + "]"
        }
        print(strMemberJson)
        
//        let membersJsonData = strMembers.data(using: .utf8)
//        let arrMembers = JSON(data:membersJsonData!)
        
        oneClassData.member = strMemberJson

        
        // 数据处理
        appDelegate.saveContext()
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    
}
