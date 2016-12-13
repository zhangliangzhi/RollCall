//
//  AddCourseViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/13.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldCourse: UITextField!



    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldCourse.delegate = self
        
        textFieldCourse.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }

    @IBAction func addOneMember(_ sender: Any) {
        // 不为空
        if textFieldCourse.text == "" {
            TipsSwift.showCenterWithText("课程名不能为空")
            return
        }
        
        // 添加课程
        let oneClassData = arrClassData[gIndexClass]
        let strCourses:String = oneClassData.course!
        

        // 修改数据
//        oneClassData.member = strMemberJson

        // 数据处理
        appDelegate.saveContext()
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    
}
