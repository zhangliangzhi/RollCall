//
//  AddClassNameViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/8.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CoreData

class AddClassNameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.delegate = self
        
    }
    
    @IBAction func addClassName(_ sender: Any) {
        // 班级名字不为空
        if textField.text == "" {
            TipsSwift.showCenterWithText("班级名字不能为空")
            return
        }
        
        // 加入一个班级名字
//        let oneClassData = ClassData(context: contextData)
        let oneClassData = NSEntityDescription.insertNewObject(forEntityName: "ClassData", into: contextData) as! ClassData
        do {
            try contextData.save()
            print("insert saved!")
        } catch let error as NSError  {
            print("Could not insert save \(error), \(error.userInfo)")
        } catch {
        }
        
        oneClassData.classname = textField.text
        oneClassData.sortID = Int64(Date().timeIntervalSince1970 * 10000)
        
        // 用json格式保存 课程类别
        let arrCourse = ["英语","数学","语文"]
        let courseData = try! JSONSerialization.data(withJSONObject: arrCourse, options: .prettyPrinted)
        let strCourseJson:String = String(data: courseData, encoding: String.Encoding.utf8)!
        oneClassData.course = strCourseJson

//        print(strJson)
        
        
        // 数据处理
        contextData.insert(oneClassData)
        appDelegate.saveContext()
        
        // 跳转上个界面
        navigationController!.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }




}
