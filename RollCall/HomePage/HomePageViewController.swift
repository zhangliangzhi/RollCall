//
//  HomePageViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import  UIKit

// coreData数据库操作接口
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let contextData = appDelegate.persistentContainer.viewContext
// coreData里的数据库内容
var arrClassData:[ClassData] = []


class HomePageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var mTableList: UITableView!
    var items: [String] = ["11", "22", "33"]

    override func viewDidLoad() {
        
//        let sessionId = "this is a test"
//        let index = sessionId.index(sessionId.endIndex, offsetBy: -1)
//        let suffix = sessionId.substring(to: index)
//        print(suffix)
        
        
        
        self.title = "首页"
        // 搜索按钮
        let mSearchButtonRight = UIBarButtonItem(title: "搜索", style: .plain, target: self, action: #selector(HomePageViewController.goSearchPage))
        self.navigationItem.rightBarButtonItem = mSearchButtonRight
        // 消息按钮
        let mMsgButtonLeft = UIBarButtonItem(title: "消息", style: .plain, target: self, action: #selector(HomePageViewController.goSearchPage))
        self.navigationItem.leftBarButtonItem = mMsgButtonLeft
        
        mTableList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        mTableList.dataSource = self
        mTableList.delegate = self;
        // 去掉多余的分割线
        mTableList.tableFooterView = UIView()
        // 去掉tabview 的分析左右间距
        mTableList.separatorInset = UIEdgeInsets.zero
        mTableList.layoutMargins = UIEdgeInsets.zero
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print(self.navigationController!.viewControllers.count)
        if (self.navigationController!.viewControllers.count > 1) { // 这里的 navigationController count 指当前APP 页面控制器出现的数量
            self.tabBarController?.tabBar.isHidden = true //隐藏tabbar
            self.automaticallyAdjustsScrollViewInsets = false //移除隐藏后留下的空白

        }else {
            self.tabBarController?.tabBar.isHidden = false // 显示tabbar
            self.automaticallyAdjustsScrollViewInsets = true

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.items.count;
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = mTableList.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
//        mTableList.separatorInset = UIEdgeInsets.zero
//        mTableList.layoutMargins = UIEdgeInsets.zero

        return cell
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mTableList?.deselectRow(at: indexPath, animated: true)
        print("点击了item=\(indexPath.row)")
      
    }
    
    func goSearchPage() {
        
        let mSearchPage = UIStoryboard(name: "SearchPage", bundle: nil).instantiateViewController(withIdentifier: "SearchPage") as! SearchPageController
         self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mSearchPage, animated: true)
       
        
        
    }
}
