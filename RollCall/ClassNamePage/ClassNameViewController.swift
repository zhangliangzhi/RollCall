//
//  ClassNameViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/4.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

// coreData数据库操作接口
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let contextData = appDelegate.persistentContainer.viewContext
// coreData里的数据库内容
var arrClassData:[ClassData] = []

class ClassNameViewController: UITableViewController {
    
    

    
    @IBOutlet weak var cnTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem

        
        self.title = "班级列表"
        // add
        let mSearchButtonRight = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ClassNameViewController.addClassNamePage))
        self.navigationItem.rightBarButtonItem = mSearchButtonRight
        // edit
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        let unib = UINib(nibName: "ClassNameTableViewCell", bundle: nil)
        cnTableView.register(unib, forCellReuseIdentifier: "cncell")

       


    }

    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        cnTableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrClassData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "classNameCellIdentifier", for: indexPath)
        

        
        // Configure the cell...
//        cell.textLabel?.text = String(indexPath.row)
        

        
        // 数据源
        let cell = tableView.dequeueReusableCell(withIdentifier: "cncell", for: indexPath) as! ClassNameTableViewCell
        
        // 右侧按钮图片
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        
        cell.mName.text = arrClassData[indexPath.row].classname

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let oneClassName = arrClassData[indexPath.row]
            contextData.delete(oneClassName)
            appDelegate.saveContext()
            
            arrClassData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        print(fromIndexPath.row, to.row)
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addClassNamePage() {
        let mAddClassNamePage = UIStoryboard(name: "ClassName", bundle: nil).instantiateViewController(withIdentifier: "AddClassNamePage") as! AddClassNameViewController
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mAddClassNamePage, animated: true)
    }
    
    // 获取coreData数据
    func getCoreData() {
        do{
            arrClassData = try contextData.fetch(ClassData.fetchRequest())
        }catch{
            print("fetch core data error")
        }
        
    }

}
