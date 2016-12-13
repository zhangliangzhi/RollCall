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
        
        self.navigationController?.navigationBar.topItem?.title = "当前班级：" + arrClassData[gIndexClass].classname!
        
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
        cell.textLabel?.text = id
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
            let membersJsonData = strMembers.data(using: .utf8)
            var arrMembers = JSON(data:membersJsonData!)
//            print(arrMembers.description)
            arrMembers[indexPath.row] = ""
            var newStrMember = "["
            for i in 0..<arrMembers.count {
                let strOneJson:String = arrMembers[i].description
                if strOneJson != "" {
                    if i == arrMembers.count - 1 {
                        newStrMember = newStrMember + arrMembers[i].description
                    } else {
                        newStrMember = newStrMember + arrMembers[i].description + ","
                    }
                }
            }
            newStrMember += "]"
            
//            print(newStrMember)
            arrClassData[gIndexClass].member = newStrMember
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
