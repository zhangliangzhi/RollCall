//
//  MultAddViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2017/1/8.
//  Copyright © 2017年 xigk. All rights reserved.
//

import UIKit
import Toaster

class MultAddViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var mTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTextView.delegate = self
        self.title = "名字间用逗号隔开"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mTextView.text = ""
    }

    // 导入
    @IBAction func mumInAction(_ sender: Any) {
        let allname:String = mTextView.text
        if allname == "" {
            TipsSwift.showTopWithText("没有内容")
            return
        }
        
        // id
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        let lastId = arrMembers[arrMembers.count-1]["id"]
        var iLastID:Int32 = 1
        if lastId != JSON.null {
            iLastID = Int32(lastId.description)! + 1
        }
        
        
        
        let arrn = allname.components(separatedBy: ",")
        for i in 0..<arrn.count {
            let name:String = arrn[i]
//            print(name)
            
            // 去除头尾空格
            var getMemName:String = name
            getMemName = getMemName.trimmingCharacters(in: .whitespaces)

            // 名字不为空
            if getMemName == "" {
                TipsSwift.showCenterWithText("名字不能为空")
                return
            }
            //  学号为是数字
            let num = iLastID
            
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
            arrCMember.append(CMember(name: getMemName, id: num))
            
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
            
            // 修改数据
            arrClassData[gIndexClass].member = strMemberJson
            
            iLastID = iLastID + 1
            // umeng统计观
            MobClick.event("UMADDMEMBER")
        }
        // 数据保存
        appDelegate.saveContext()
        
        self.navigationController?.popViewController(animated: true)
        TipsSwift.showTopWithText("导入成功")
        // umeng统计观
        MobClick.event("ONEKEYADDIN")
    }
    
    // 导出
    @IBAction func memOutAction(_ sender: Any) {
        // umeng统计观
        MobClick.event("ONEKEYADDOUT")
        
        var getNames = ""
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        if arrMembers.count == 0 {
            return
        }
        
        for i in 0..<arrMembers.count {
            let name:String = arrMembers[i]["name"].stringValue
            getNames = getNames + name
            if i != arrMembers.count - 1 {
                getNames = getNames +  ","
            }
        }
        mTextView.text = getNames
        UIPasteboard.general.string = getNames
        TipsSwift.showTopWithText("成功复杂到剪切板")
        Toast(text: "把成员列表，粘贴发送给其他人吧！").show()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text  == "\n" {
            mTextView.resignFirstResponder()
        }
        return true
    }

}
