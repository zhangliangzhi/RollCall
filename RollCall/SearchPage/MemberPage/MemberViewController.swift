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
        let strMembers:String = arrClassData[mIndexClass].course!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        return arrMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let strMembers:String = arrClassData[mIndexClass].course!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        
        let member:String = arrMembers[indexPath.row].string!
        cell.textLabel?.text = member
        
        return cell
    }
    
    func addClassMemberPage() {
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
