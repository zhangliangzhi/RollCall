//
//  AddClassNameViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/8.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import CoreData
import SwiftDate

class AddClassNameViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.delegate = self
        
        textField.becomeFirstResponder()
    }
    
    @IBAction func addClassName(_ sender: Any) {
        // 去除头尾空格
        var getClassName:String = textField.text!
        getClassName = getClassName.trimmingCharacters(in: .whitespaces)
        
        // 班级名字不为空
        if getClassName == "" {
            TipsSwift.showCenterWithText("班级名字不能为空")
            return
        }
        
        // 班级名字不能重复
        for i in 0..<arrClassData.count {
            if arrClassData[i].classname == getClassName {
                TipsSwift.showCenterWithText("班级名字不能重复")
                return
            }
        }
        
        // 加入一个班级名字
//        let oneClassData = ClassData(context: contextData)
        let oneClassData = NSEntityDescription.insertNewObject(forEntityName: "ClassData", into: contextData) as! ClassData
        // 老版本保存方法,现在不需要了

//        do {
//            try contextData.save()
//            print("insert saved!")
//        } catch let error as NSError  {
//            print("Could not insert save \(error), \(error.userInfo)")
//        }

        
        oneClassData.classname = getClassName
        oneClassData.sortID = Int64(Date().timeIntervalSince1970 * 10000)
        
        // 用json格式保存 课程类别
        let arrCourse = ["英语","数学","语文"]
        let courseData = try! JSONSerialization.data(withJSONObject: arrCourse, options: .prettyPrinted)
        let strCourseJson:String = String(data: courseData, encoding: String.Encoding.utf8)!
        oneClassData.course = strCourseJson
        
        // 选中的课程类别
        oneClassData.selCourse = "英语"
        oneClassData.wc = 1
        // 其他的先设置为json格式的
        oneClassData.member = "[]"
        oneClassData.record = "[]"

        // 时间设置
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyy-MM-dd"
//        dformatter.timeZone = NSTimeZone.system
//        let resultDate:String = dformatter.string(from: Date())

        let ndate = DateInRegion(absoluteDate: Date() )
        let strndate = ndate.string(format: DateFormat.custom("yyyy-MM-dd"))
        oneClassData.dateStart = strndate
        
        let enddate = ndate + 6.month
        oneClassData.dateEnd = enddate.string(format: DateFormat.custom("yyyy-MM-dd"))
        
//        print(oneClassData.dateStart)
//        print(oneClassData.dateEnd)

        // umeng统计观看次数
        MobClick.event("UMADDCLASS")
        
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
