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
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        
        return cell
    }
    
    func addClassMemberPage() {
        let mAddClassNamePage = UIStoryboard(name: "Member", bundle: nil).instantiateViewController(withIdentifier: "AddClassMemberPage") as! AddClassMemberViewController
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mAddClassNamePage, animated: true)
    }
}
