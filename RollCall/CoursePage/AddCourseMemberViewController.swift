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
        // 去除头尾空格
        var getCourseName:String = textFieldCourse.text!
        getCourseName = getCourseName.trimmingCharacters(in: .whitespaces)
        // 不为空
        if getCourseName == "" {
            TipsSwift.showCenterWithText("课程名不能为空")
            return
        }
        
        // 添加课程 1.转JSON 2.保存新array 3.转新JSON 最后保存.description
        let strCourses:String = arrClassData[gIndexClass].course!
        let coursesJsonData = strCourses.data(using: .utf8)
        var arrCourses = JSON(data:coursesJsonData!)
        

        // 课程名 不能重复
        for i in 0..<arrCourses.count {
            if arrCourses[i].stringValue == getCourseName{
                TipsSwift.showCenterWithText("课程名不能重复")
                return
            }
        }
        
        var arrNewCourse: [String] = []
        for i in 0..<arrCourses.count {
            arrNewCourse.append(arrCourses[i].stringValue)
        }
        arrNewCourse.append(getCourseName)
        
        let newJson = JSON.init(arrNewCourse)
//        print(newJson.description)

        // 数据处理
        arrClassData[gIndexClass].course = newJson.description
        appDelegate.saveContext()
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    
}
