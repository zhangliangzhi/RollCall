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
    
    // 班级序列号
    var mIndexClass = 0
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        
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
        let strMembers:String = arrClassData[mIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        return arrMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let strMembers:String = arrClassData[mIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        // coreData里的member字段格式 {"id":1, "name":"a1"}
        let member:String = arrMembers[indexPath.row]["name"].string!
        cell.textLabel?.text = member
        
        return cell
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
