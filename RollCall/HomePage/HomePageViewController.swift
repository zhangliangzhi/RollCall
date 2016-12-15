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
import CoreData

// coreData数据库操作接口
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let contextData = appDelegate.persistentContainer.viewContext
// coreData里的数据库内容
var arrClassData:[ClassData] = []
var arrCallFair:[CallFair] = []
var arrCurGlobalSet:[CurGlobalSet]=[]

// 班级序列号
var gIndexClass = 0

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var curCoursePage: UILabel!

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var curNameLabel: UILabel!
    
    override func viewDidLoad() {
        


        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "西瓜点名"
        // 右侧按钮
        let mRightButton = UIBarButtonItem(title: "帮助", style: .plain, target: self, action: #selector(HomePageViewController.goDescHelpPage))
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
        firstOpenAPP()
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
        
        // 选中状态
        if indexPath.row == gIndexClass {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }

    // 选中班级
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gIndexClass = indexPath.row
        arrCurGlobalSet[0].classIndex = Int32(gIndexClass)
        let className:String = arrClassData[indexPath.row].classname!
        
        curNameLabel.text = className
        curCoursePage.text = arrClassData[indexPath.row].selCourse
        
        TipsSwift.showTopWithText("选中班级: " + className)
        
        // 进入选课程界面
        
        appDelegate.saveContext()
    }

    // 获取coreData数据
    func getCoreData() {
        do{
            arrClassData = try contextData.fetch(ClassData.fetchRequest())
            arrClassData.sort(by: { $0.sortID > $1.sortID })
        }catch{
            print("fetch core data ClassData error")
        }
        
        do{
            arrCallFair = try contextData.fetch(CallFair.fetchRequest())
        }catch{
            print("fetch core data CallFair error")
        }
        do{
            arrCurGlobalSet = try contextData.fetch(CurGlobalSet.fetchRequest())
        }catch{
            print("fetch core data CurGlobalSet error")
        }
        
        
        
        if gIndexClass < arrClassData.count {
            curNameLabel.text = arrClassData[gIndexClass].classname
            curCoursePage.text = arrClassData[gIndexClass].selCourse
        } else {
            curNameLabel.text = "还没有创建班级"
            curCoursePage.text = "还没有创建班级"
        }
    }
    

    func goDescHelpPage() {
        let mPage = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "DescHelpPage") as! DescHelpViewController
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mPage, animated: true)
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
        let fairMemId = getRandomMemId()
        if fairMemId.id < 0 {
            return
        }

        let name:String = fairMemId.name
        let id:Int32 = fairMemId.id
        
        TipsSwift.showCenterWithText("点名：" + name)
        
        // 保存一条记录 时间，学号
//        let nowdate = DateInRegion(absoluteDate: Date())
//        let strDate = nowdate.string(format: DateFormat.custom("yyyy-MM-dd HH:mm:ss"))
        let oneCallFair = NSEntityDescription.insertNewObject(forEntityName: "CallFair", into: contextData) as! CallFair
        oneCallFair.classname = arrClassData[gIndexClass].classname
        oneCallFair.course = arrClassData[gIndexClass].selCourse
        oneCallFair.date = NSDate()
        oneCallFair.memID = id
//        contextData.insert(oneCallFair)
        arrCallFair.append(oneCallFair)
        appDelegate.saveContext()
        
        
    }
    
    // 成员id:次数
    struct MemCount {
        let id:Int32    // member id
        var count:Int32 // count
        var name:String // name
    }
    
    func getRandomMemId() -> MemCount {
        let dateStart:String = arrClassData[gIndexClass].dateStart!
        let dateEnd:String = arrClassData[gIndexClass].dateEnd!
        let startTime = try! DateInRegion.init(string: dateStart, format: DateFormat.custom("yyyy-MM-dd"))
        let endTime = try! DateInRegion.init(string: dateEnd, format: DateFormat.custom("yyyy-MM-dd"))
        let nowTime = DateInRegion(absoluteDate: Date())
        if nowTime > endTime {
            TipsSwift.showBottomWithText("先设置时间, 截止时间小于当前时间")
            return MemCount.init(id: -1, count: 0, name: "")
        }
        
        var arrMemID:[MemCount] = []
        // 获取所有成员id
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        var arrMembers = JSON(data:membersJsonData!)
        for i in 0..<arrMembers.count {
            let id:Int32 = arrMembers[i]["id"].int32Value
            arrMemID.append(MemCount.init(id: id, count: 0, name: arrMembers[i]["name"].stringValue) )
        }
        
        // 统计目前时间范围内的 次数
        for i in 0..<arrCallFair.count {
            let one = arrCallFair[i]
            let onedate = DateInRegion.init(absoluteDate: one.date as! Date)
            let id = one.memID
            // 统计在时间范围内的次数
            if onedate >= startTime && onedate <= endTime {
                for j in 0..<arrMemID.count {
                    if arrMemID[j].id == id {
                        arrMemID[j].count += 1
                        break
                    }
                }
            }
        }
        arrMemID.sort(by: {$0.count < $1.count})
//        print(arrMemID)
        
        // 获取最低次数的所有人
        var minCountMems:[MemCount] = []
        for i in 0..<arrMemID.count {
            if arrMemID[0].count == arrMemID[i].count {
                minCountMems.append(arrMemID[i])
            }
        }
        // 众minCountMems里面，随机去一个学号id
//        print(minCountMems)
        let nCount:UInt32 = UInt32(minCountMems.count)
        let getRanIndex:Int = Int(arc4random_uniform(nCount))
        let getNewMemId = minCountMems[getRanIndex]
//        print(getNewMemId)
        
        return getNewMemId
    }
    
    @IBAction func goSetTimePage(_ sender: Any) {
        if arrClassData.count == 0 {
            TipsSwift.showCenterWithText("需要先创建班级")
            return
        }

        let mDateShowPage = UIStoryboard(name: "HomePage", bundle: nil).instantiateViewController(withIdentifier: "DateShowPage") as! DateShowViewController
        navigationController?.pushViewController(mDateShowPage, animated: true)
        
    }
    
    // 第一次打开app，加入测试数据
    func firstOpenAPP() -> Void {
        if arrCurGlobalSet.count > 0 {
            gIndexClass = Int(arrCurGlobalSet[0].classIndex)
            return
        }
        // 1.全局设置
        let oneGlobalSet = NSEntityDescription.insertNewObject(forEntityName: "CurGlobalSet", into: contextData) as! CurGlobalSet
        oneGlobalSet.classIndex = 0
        contextData.insert(oneGlobalSet)
        
        // 2. 加入班级测试数据
        let oneClassData = NSEntityDescription.insertNewObject(forEntityName: "ClassData", into: contextData) as! ClassData
        oneClassData.classname = "我的班级"
        oneClassData.sortID = Int64(Date().timeIntervalSince1970 * 10000)
        let arrCourse = ["英语","数学","语文"]
        let courseData = try! JSONSerialization.data(withJSONObject: arrCourse, options: .prettyPrinted)
        let strCourseJson:String = String(data: courseData, encoding: String.Encoding.utf8)!
        oneClassData.course = strCourseJson
        oneClassData.selCourse = "英语"
        oneClassData.member = "[{\"id\":\"1\",\"name\":\"张三\"},{\"id\":\"2\",\"name\":\"李四\"},{\"id\":\"3\",\"name\":\"王五\"}]"
        oneClassData.record = "[]"
        let ndate = DateInRegion(absoluteDate: Date() )
        let strndate = ndate.string(format: DateFormat.custom("yyyy-MM-dd"))
        oneClassData.dateStart = strndate
        let enddate = ndate + 6.month
        oneClassData.dateEnd = enddate.string(format: DateFormat.custom("yyyy-MM-dd"))
        contextData.insert(oneClassData)
        appDelegate.saveContext()
        getCoreData()
    }
}
