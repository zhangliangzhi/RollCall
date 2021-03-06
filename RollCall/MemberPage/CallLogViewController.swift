//
//  CallLogViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/15.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import SwiftDate

class CallLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "随机点名历史记录"
        // edit
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        tableView.reloadData()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing,animated: animated)
        tableView.setEditing(editing, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCallFair.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logcell", for: indexPath) as! CallLogTableViewCell
        
        // 时间倒序
        let index = arrCallFair.count - indexPath.row - 1
        let one = arrCallFair[index]
        let getDate = DateInRegion(absoluteDate: one.date as! Date)
        let timestr:String = getDate.string(format: DateFormat.custom("yyyy-MM-dd\nHH:mm:ss"))
        cell.timeLabel.text = timestr
        cell.classLabel.text = one.classname
        cell.courseLabel.text = one.course
        cell.idLabel.text = String(one.memID) + "号"
        cell.memLabel.text = one.memName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 倒序
            let delRow = arrCallFair.count - indexPath.row - 1
            let one = arrCallFair[delRow]
            contextData.delete(one)
            appDelegate.saveContext()
            arrCallFair.remove(at: delRow)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // 获取coreData数据
    func getCoreData() {
        do{
            arrCallFair = try contextData.fetch(CallFair.fetchRequest())
        }catch{
            print("fetch rollfair data error")
        }
    }

}




