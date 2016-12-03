//
//  MainTableViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/26.
//  Copyright © 2016年 xigk. All rights reserved.
//

import UIKit
import Alamofire
import CloudKit

// 1.应用 CloudKit 框架并获得公开数据库
let publicDB = CKContainer.default().publicCloudDatabase

// 2.新建一个位置信息并存储
let atworkRecordID = CKRecordID.init(recordName: "Cats")
let atworkRecord = CKRecord.init(recordType: "CatsType", recordID: atworkRecordID)


class MainTableViewController: UITableViewController {

    @IBOutlet weak var mTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

//        self.DownLoadData()
        

        atworkRecord["name"] = "cy" as CKRecordValue?
        atworkRecord["per"] = "99%" as CKRecordValue?
        atworkRecord["address"]="广州" as CKRecordValue?

        print("ok")
        
        
        creatRecord()
    }
    
    
    
    func fetchRecordData() {
        //在代码中获取我们保存好的内容
        publicDB.fetch(withRecordID: atworkRecordID) { (artworkRecord, error) in
            if (error != nil) {
                print("selectData failure！")
            } else {
                print("selectData success！")
                let per = artworkRecord!["per"];
                let names = artworkRecord!["name"];
                let address = artworkRecord!["address"];
                
                print("查询信息：" ,"per:",per ,"names:", names ,"address:" , address)
            }
        }
    }
    func creatRecord() {
        //将记录保存在数据库
        publicDB.save(atworkRecord) { (artworkRecord, error) in
            
            self.fetchRecordData()
            
            if (error != nil) {
                print("creatRecord failure！")
            } else {
                print("creatRecord success！")
            }
        }
    }
    func unpdateData() {
        //修改数据
        atworkRecord["name"] = "创业1%" as CKRecordValue?
        //将记录保存在数据库
        publicDB.save(atworkRecord) { (artworkRecord, error) in
            if (error != nil) {
                print("unpdateData failure！")
            } else {
                print("unpdateData success！")
            }
        }
    }
    func deleteRecordData() {
        //将记录保存在数据库
        publicDB.delete(withRecordID: atworkRecordID) { (artworkRecord, error) in
            if (error != nil) {
                print("deleteRecord failure！")
            } else {
                print("deleteRecord success！")
            }
        }
    }
    
    

    func DownLoadData() -> Void {

        Alamofire.request("http://apis.baidu.com/heweather/weather/free", method: .get).responseJSON {
            (response)   in
            
            print(response.result)

            // 有错误就打印错误，没有就解析数据
            if let Error = response.result.error
            {
                print(Error)
            }
            else if let jsonresult = response.result.value {
                // 用 SwiftyJSON 解析数据
                let JSOnDictory = JSON(jsonresult )
                print(JSOnDictory)
                
//                self.mTableView.reloadData()
                

                
            }
        }
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
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mcellIdentifier", for: indexPath)

        // Configure the cell...
//        let model = self.dataArray[indexPath.row]
//        cell.textLabel?.text = model.likecount
        cell.textLabel?.text = String(indexPath.row)
        
        // 这个就是用到 Kingfisher
//        cell.backGroundImage.kf_setImageWithURL(NSURL(string: model.cover_image_url)!)

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
