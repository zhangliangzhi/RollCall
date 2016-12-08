//
//  ClassNameViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/12/4.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit

class ClassNameViewController: UITableViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var arrData = [1,2,3,4,5,6,7,8]
    // coreData里的数据库内容
    var arrClassData:[ClassData] = []
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "classNameCellIdentifier", for: indexPath)
        

        
        // Configure the cell...
//        cell.textLabel?.text = String(indexPath.row)
        

        
        // 数据源
        let cell = tableView.dequeueReusableCell(withIdentifier: "cncell", for: indexPath) as! ClassNameTableViewCell
        
        // 右侧按钮图片
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
//        cell.detailTextLabel?.text = "aaa"
        
        cell.mName.text = String(arrData[indexPath.row])

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
            // Delete the row from the data source
            arrData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            arrData.append(00)
//            let ip = IndexPath(row: 1, section: 0)
//            tableView.insertRows(at: [ip], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            arrData.append(00)
            let ip = IndexPath(row: 1, section: 0)
            tableView.insertRows(at: [ip], with: .automatic)
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

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

}
