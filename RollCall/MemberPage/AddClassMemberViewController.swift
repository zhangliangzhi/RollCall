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
        
        let multAddBtn = UIBarButtonItem(title: "一键导入", style: .plain, target: self, action: #selector(multiAdd))
        self.navigationItem.rightBarButtonItem = multAddBtn
        
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        let lastId = arrMembers[arrMembers.count-1]["id"]
        var iLastID:Int32 = 1
        if lastId != JSON.null {
            iLastID = Int32(lastId.description)! + 1
        }
        textNum.text = String(iLastID)
        textName.becomeFirstResponder()
    }
    
    func multiAdd() {
        let muladd = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "multadd") as! MultAddViewController
        self.navigationController?.pushViewController(muladd, animated: true)
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
        // 去除头尾空格
        var getMemName:String = textName.text!
        getMemName = getMemName.trimmingCharacters(in: .whitespaces)
        var getMemID:String = textNum.text!
        getMemID = getMemID.trimmingCharacters(in: .whitespaces)
        
        // 名字不为空
        if getMemName == "" {
            TipsSwift.showCenterWithText("名字不能为空")
            return
        }
        // 学号不为空
        if getMemID == "" {
            TipsSwift.showCenterWithText("学号不能为空")
            return
        }
        //  学号为是数字
        let num = Int32(getMemID)
        if num == nil || num! < 0 {
            TipsSwift.showCenterWithText("学号只能为数字")
            return
        }
        
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        var arrMembers = JSON(data:membersJsonData!)
        // 学号不能重复
        for i in 0..<arrMembers.count {
            if num == arrMembers[i]["id"].int32Value {
                TipsSwift.showCenterWithText("学号不能重复")
                return
            }
        }

        // 加一个成员
        var arrCMember:[CMember] = []
        for i in 0..<arrMembers.count {
            arrCMember.append(CMember(name: arrMembers[i]["name"].stringValue, id: arrMembers[i]["id"].int32Value))
        }
        arrCMember.append(CMember(name: getMemName, id: num!))
        
        var strMemberJson:String = "["
        for i in 0..<arrCMember.count {
            let onem = arrCMember[i]
            if i == arrCMember.count - 1 {
                strMemberJson = strMemberJson + onem.toJSON()!
            }else {
                strMemberJson = strMemberJson + onem.toJSON()! + ","
            }
        }
        strMemberJson += "]"
        
//        print(strMemberJson)
        
        // 修改数据
        arrClassData[gIndexClass].member = strMemberJson

        // 数据处理
        appDelegate.saveContext()
        
        // umeng统计观
        MobClick.event("UMADDMEMBER")
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    
}
