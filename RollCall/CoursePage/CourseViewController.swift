//
//  CourseViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/13.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import UIKit
class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {

        getCoreData()
        
        if arrClassData.count > 0 {
            self.navigationController?.navigationBar.topItem?.title = "当前班级：" + arrClassData[gIndexClass].classname!
        } else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // add
        let mSearchButtonRight = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CourseViewController.addClassCoursePage))
        self.navigationItem.rightBarButtonItem = mSearchButtonRight
        // edit
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strCourses:String = arrClassData[gIndexClass].course!
        let coursesJsonData = strCourses.data(using: .utf8)
        let arrCourses = JSON(data:coursesJsonData!)
        let curCourse = arrCourses[indexPath.row].stringValue
        let tips = "选中课程" + curCourse
        TipsSwift.showCenterWithText(tips)
        arrClassData[gIndexClass].selCourse = curCourse
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing,animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("请先创建班级!")
            return 0
        }
        let strCourses:String = arrClassData[gIndexClass].course!
        let coursesJsonData = strCourses.data(using: .utf8)
        let arrCourses = JSON(data:coursesJsonData!)
        
        return arrCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coursecell", for: indexPath) as! CourseTableViewCell
        
        let strCourses:String = arrClassData[gIndexClass].course!
        let coursesJsonData = strCourses.data(using: .utf8)
        let arrCourses = JSON(data:coursesJsonData!)
        
        // coreData里的course字段格式 [“a","b","c"]
        let course:String = arrCourses[indexPath.row].string!
        cell.courseLabel.text = course
        
        // 选中状态
        if course == arrClassData[gIndexClass].selCourse {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // 删除一个成员 1.转JSON 2.保存新array 3.转新JSON 最后保存.description
            let strCourses:String = arrClassData[gIndexClass].course!
            let coursesJsonData = strCourses.data(using: .utf8)
            var arrCourses = JSON(data:coursesJsonData!)
            
            // 如果只有一个科目的话，不能删除
            if arrCourses.count <= 1 {
                TipsSwift.showCenterWithText("不可删除，一个班级至少对应一个课程")
                return
            }
            
            // 如果是选中的课程，则改为选第一个课程
            if arrCourses[indexPath.row].stringValue == arrClassData[gIndexClass].selCourse {
                arrClassData[gIndexClass].selCourse = arrCourses[0].stringValue
            }
            
            var arrNewCourse: [String] = []
            for i in 0..<arrCourses.count {
                if i != indexPath.row {
                    arrNewCourse.append(arrCourses[i].stringValue)
                }
            }
            
//            print(arrNewCourse)
            let newJson = JSON.init(arrNewCourse)
            
            arrClassData[gIndexClass].course = newJson.description
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
//        print(sourceIndexPath.row ,destinationIndexPath.row)
        if sourceIndexPath.row == destinationIndexPath.row {
            return
        }
        
        // 移动科目的排练顺序
        let strCourses:String = arrClassData[gIndexClass].course!
        let coursesJsonData = strCourses.data(using: .utf8)
        var arrCourses = JSON(data:coursesJsonData!)
        
        var arrNewCourse: [String] = []
        for i in 0..<arrCourses.count {
            arrNewCourse.append(arrCourses[i].stringValue)
        }
        let strTmp = arrNewCourse[sourceIndexPath.row]
        if sourceIndexPath.row > destinationIndexPath.row {
            arrNewCourse.remove(at: sourceIndexPath.row)
            arrNewCourse.insert(strTmp, at: destinationIndexPath.row)
        }else{
            arrNewCourse.insert(strTmp, at: destinationIndexPath.row+1)
            arrNewCourse.remove(at: sourceIndexPath.row)
        }
        
//        print(arrNewCourse)
//        print(arrNewCourse.description)
        let newJson = JSON.init(arrNewCourse)
        arrClassData[gIndexClass].course = newJson.description
        appDelegate.saveContext()
    }
    
    func addClassCoursePage() {
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("请先创建班级!")
            return
        }
        
        let mAddClassNamePage = UIStoryboard(name: "Course", bundle: nil).instantiateViewController(withIdentifier: "AddCoursePage") as! AddCourseViewController
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mAddClassNamePage, animated: true)
    }
    

    
    // 获取coreData数据
    func getCoreData() {
        do{
            arrClassData = try contextData.fetch(ClassData.fetchRequest())
            arrClassData.sort(by: { $0.sortID > $1.sortID })
        }catch{
            print("fetch core data error")
        }
    }
}
