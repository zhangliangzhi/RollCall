//
//  HomePageViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import  UIKit
import SwiftDate

// coreData数据库操作接口
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let contextData = appDelegate.persistentContainer.viewContext
// coreData里的数据库内容
var arrClassData:[ClassData] = []

// 班级序列号
var gIndexClass = 0

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var curCoursePage: UILabel!

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var curNameLabel: UILabel!
    
    override func viewDidLoad() {
        
//        let ndate = DateInRegion(absoluteDate: Date() )
//        print(ndate + 1.day)
//        let str = ndate.string(format: DateFormat.custom("yyyy-MM-dd"))
//        print(str)
        
//        let date_custom = try! DateInRegion(string: "2016-12-13", format: DateFormat.custom("yyyy-MM-dd"))
//        print(date_custom + 6.month)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "西瓜点名"
        // 右侧按钮
        let mRightButton = UIBarButtonItem(title: "帮助", style: .plain, target: self, action: #selector(HomePageViewController.goSearchPage))
        self.navigationItem.rightBarButtonItem = mRightButton
        
    }
    
    // 第一级目录不显示导航按钮
    override func viewWillAppear(_ animated: Bool) {
        if (self.navigationController!.viewControllers.count > 1) { // 这里的 navigationController count 指当前APP 页面控制器出现的数量
            self.tabBarController?.tabBar.isHidden = true //隐藏tabbar
            self.automaticallyAdjustsScrollViewInsets = false //移除隐藏后留下的空白

        }else {
            self.tabBarController?.tabBar.isHidden = false // 显示tabbar
            self.automaticallyAdjustsScrollViewInsets = true

        }
        getCoreData()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrClassData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homecell", for: indexPath) as! HomeTableViewCell
        
        cell.nameLabel.text = arrClassData[indexPath.row].classname
//        cell.textLabel?.text = String(indexPath.row)
        return cell
    }

    // 选中班级
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gIndexClass = indexPath.row
        let className:String = arrClassData[indexPath.row].classname!
        
        curNameLabel.text = className
        
        
    }

    // 获取coreData数据
    func getCoreData() {
        do{
            arrClassData = try contextData.fetch(ClassData.fetchRequest())
            arrClassData.sort(by: { $0.sortID > $1.sortID })
        }catch{
            print("fetch core data error")
        }
        
        if gIndexClass < arrClassData.count {
            curNameLabel.text = arrClassData[gIndexClass].classname
            curCoursePage.text = arrClassData[gIndexClass].selCourse
        } else {
            curNameLabel.text = "还没有创建班级"
            curCoursePage.text = "还没有创建班级"
        }
    }
    
    func goSearchPage() {
        
        let mSearchPage = UIStoryboard(name: "SearchPage", bundle: nil).instantiateViewController(withIdentifier: "SearchPage") as! SearchPageController
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mSearchPage, animated: true)

    }
    
    @IBAction func goRandom(_ sender: Any) {
        // 随机点名
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("需要先创建班级")
            return
        }
        // 没有成员
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        let arrMembers = JSON(data:membersJsonData!)
        let iCount = arrMembers.count
        if iCount == 0 {
            TipsSwift.showCenterWithText("先增加班级成员")
            return
        }
        let nCount:UInt32 = UInt32(iCount)
        let strRandom:String = String(arc4random_uniform(nCount))
//        print(strRandom)
        let iRandom:Int = Int(strRandom)!
        let pathName: [JSONSubscriptType] = [iRandom,"name"]
        let pathID: [JSONSubscriptType] = [iRandom,"id"]
        let name = arrMembers[pathName].string
        let id:Int32 = arrMembers[pathID].int32Value

        TipsSwift.showCenterWithText("点名：" + name!)
        
        // 保存一条记录 时间，学号
        let nowdate = DateInRegion(absoluteDate: Date())
        let strDate = nowdate.string(format: DateFormat.custom("yyyy-MM-dd"))
        let record = CRecord(time: strDate, cou: "我的", mid: id)
        print(record)
        
    }
    
    @IBAction func goSetTimePage(_ sender: Any) {
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("需要先创建班级")
            return
        }

        let mDateShowPage = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "DateShowPage") as! DateShowViewController
        navigationController?.pushViewController(mDateShowPage, animated: true)
        
    }
    
}
