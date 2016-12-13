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
//            print(arrCourses.description)
            
            var arrNewCourse: [String] = []
            for i in 0..<arrCourses.count {
                if i != indexPath.row {
                    arrNewCourse.append(arrCourses[i].stringValue)
                }
            }
            
//            print(arrNewCourse)
            let newJson = JSON.init(arrNewCourse)
            print(newJson.description)
            
            arrClassData[gIndexClass].course = newJson.description
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
