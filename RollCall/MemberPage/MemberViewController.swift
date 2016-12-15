//
//  MemberViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import UIKit
class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    

    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        if arrClassData.count > 0 {
            self.navigationController?.navigationBar.topItem?.title = "当前班级：" + arrClassData[gIndexClass].classname!
        } else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        memberSortById()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // add
        let mSearchButtonRight = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MemberViewController.addClassMemberPage))
        self.navigationItem.rightBarButtonItem = mSearchButtonRight
        // edit
        self.navigationItem.leftBarButtonItem = self.editButtonItem
//        tableView.setEditing(true, animated: true)
        
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
        
        return cell
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
