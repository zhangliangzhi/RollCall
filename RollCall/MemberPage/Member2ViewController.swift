//
//  MemberViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate
import Firebase


class Member2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var homeView:HomePageViewController!
    var arrMemCount = [Int32:Int]()
    //var arrMemCount = Dictionary<Int32, Int>()
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        if arrClassData.count > 0 {
//            self.navigationController?.navigationBar.topItem?.title = arrClassData[gIndexClass].classname! + "|" + arrClassData[gIndexClass].selCourse!
        } else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        
        self.title  = "指定成员点名"
//        self.navigationController?.navigationBar.topItem?.title = "指定成员点名"
        
        
        // 注意判断arrClassData.count == 0时的情
        memberSortById()
        getArrMemCount()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing,animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("请先创建班级!")
            return 0
        }
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        return arrMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memcell", for: indexPath) as! MemberTableViewCell
        
        
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        // coreData里的member字段格式 {"id":1, "name":"a1"}
        let member:String = arrMembers[indexPath.row]["name"].string!
        let id:String = arrMembers[indexPath.row]["id"].description
        
        cell.numLabel.text = id
        cell.memLabel.text = member
        
        let iMemID:Int32 = arrMembers[indexPath.row]["id"].int32Value
        let imemcount:Int = arrMemCount[iMemID]!
        cell.countLabel.text = String(imemcount)
        
        return cell
    }
    
    // 获取成员的总点名次数
    func getArrMemCount() -> Void {
        if arrClassData.count == 0 {
            return
        }
        let dateStart:String = arrClassData[gIndexClass].dateStart!
        let dateEnd:String = arrClassData[gIndexClass].dateEnd!
        let startTime = try! DateInRegion.init(string: dateStart, format: DateFormat.custom("yyyy-MM-dd"))
        let endTime = try! DateInRegion.init(string: dateEnd, format: DateFormat.custom("yyyy-MM-dd"))

        arrMemCount = [:]
        // 获取所有成员id
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        var arrMembers = JSON(data:membersJsonData!)
        for i in 0..<arrMembers.count {
            let id:Int32 = arrMembers[i]["id"].int32Value
            arrMemCount[id] = 0
        }
        
        // 先删除没用的数据
        
        // 统计目前时间范围内的 次数
        for i in 0..<arrCallFair.count {
            let one = arrCallFair[i]
            let onedate = DateInRegion.init(absoluteDate: one.date as! Date)
            let id = one.memID
            // 统计在时间范围内的次数
            if onedate >= startTime && onedate <= endTime {
                // 是选定课程
                if arrClassData[gIndexClass].selCourse == one.course {
                    if arrMemCount[id] != nil{
                        arrMemCount[id] = arrMemCount[id]! + 1
                    }else {
                        //del
                    }
                }
            }
        }
//        print(arrMemCount)

        return
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 删除一个成员
            let strMembers:String = arrClassData[gIndexClass].member!
            
//            strMembers = strMembers.replacingOccurrences(of: "\n", with: "")
//            strMembers = strMembers.replacingOccurrences(of: "\r", with: "")
//            strMembers = strMembers.replacingOccurrences(of: "[  {", with: "[{")
//            strMembers = strMembers.replacingOccurrences(of: "    ", with: "")
//            strMembers = strMembers.replacingOccurrences(of: "},  ", with: "},")
//            strMembers = strMembers.replacingOccurrences(of: "  }", with: "}")
//            strMembers = strMembers.replacingOccurrences(of: " : ", with: ":")
            
            let membersJsonData = strMembers.data(using: .utf8)
            var arrMembers = JSON(data:membersJsonData!)
            
            arrMembers[indexPath.row] = ""
            var strNewMem:String = arrMembers.description
            // 字符串 替换3种 "", 或者 ,""  或者[""]
//            print(strNewMem)
            strNewMem = strNewMem.replacingOccurrences(of: "\n  \"\",", with: "")
            strNewMem = strNewMem.replacingOccurrences(of: ",\n  \"\"", with: "")
            
            strNewMem = strNewMem.replacingOccurrences(of: "[\n  \"\"\n]", with: "[]")
//            print(strNewMem)
            
            
            arrClassData[gIndexClass].member = strNewMem
            appDelegate.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func addClassMemberPage() {
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("请先创建班级!")
            return
        }
        
        let mAddClassNamePage = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "AddClassMemberPage") as! AddClassMemberViewController
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mAddClassNamePage, animated: true)
    }
    
    // 按学号排序
    func memberSortById() {
        if arrClassData.count == 0 {
            return
        }
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        var arrMembers = JSON(data:membersJsonData!)
        if arrMembers.count < 2 {
//            print("no 2 mem", arrMembers)
            return
        }
        
        // 排序，这够累的啊🐶，真是来回转，保存到数组！在保存回来 额
        var sortMembers:[CMember] = []
        for (_,subJson):(String, JSON) in arrMembers {
            sortMembers.append(CMember(name: subJson["name"].stringValue, id: subJson["id"].int32Value))
        }
        sortMembers.sort(by: {$0.id < $1.id})
        
        // 数组转为json格式
        for (key,_):(String, JSON) in arrMembers {
            let iKey:Int = Int(key)!
            let k : [JSONSubscriptType] = [iKey]
//            print(key, subJson)
//            print(arrMembers[k])
            arrMembers[k]["name"].string = sortMembers[iKey].name
            arrMembers[k]["id"].string = String(sortMembers[iKey].id)
        }
//        print(arrMembers)
        arrClassData[gIndexClass].member = arrMembers.description
        appDelegate.saveContext()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        print("select me ", index)
        
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        // coreData里的member字段格式 {"id":1, "name":"a1"}
        let member:String = arrMembers[indexPath.row]["name"].string!
        let id:String = arrMembers[indexPath.row]["id"].description
        let iMemID:Int32 = arrMembers[indexPath.row]["id"].int32Value
        
        homeView.callbackGddm(iMemID, member)
        navigationController?.popViewController(animated: true)
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
