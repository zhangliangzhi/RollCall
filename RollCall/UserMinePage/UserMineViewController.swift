//
//  UserMineViewController.swift
//  RollCall
//
//  Created by ZhangLiangZhi on 2016/11/24.
//  Copyright © 2016年 xigk. All rights reserved.
//

import Foundation
import  UIKit
import Charts
import SwiftDate

class UserMineViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter {
    @IBOutlet weak var barChartView: BarChartView!
    
    struct MemCount {
        let name:String
        var count:Int
        let id:Int32
    }
    var arrMemNameCount : [MemCount] = []
    
    override func viewWillAppear(_ animated: Bool) {
        if arrClassData.count > 0 {
            self.navigationController?.navigationBar.topItem?.title = arrClassData[gIndexClass].classname! + "|" + arrClassData[gIndexClass].selCourse!
        } else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        getMemCountName()
        chartsGo()
    }
    
    override func viewDidLoad() {
        barChartView.xAxis.valueFormatter = self
        barChartView.chartDescription?.text = "by 🍉西瓜点名🍉"
        
    }
    
    public func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String
    {
        return arrMemNameCount[Int(value)].name
    }
    
    func chartsGo() {
        if arrMemNameCount.count == 0 {
            TipsSwift.showCenterWithText("没有班级成员!")
        }
//        print(arrMemNameCount.count)
        var values: [Double] = []
        for i in 0..<arrMemNameCount.count {
            let d:Double = Double(arrMemNameCount[i].count)
            values.append(d)
        }
//        print(values)
        
        var entries: [ChartDataEntry] = Array()
        for (i, value) in values.enumerated()
        {
            entries.append( BarChartDataEntry(x: Double(i), y: value) )
        }
        
        let dataSet: BarChartDataSet = BarChartDataSet(values: entries, label: "点名次数")

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.85
        dataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        barChartView.backgroundColor = NSUIColor.clear
        barChartView.xAxis.labelPosition = .bottom
        let xAxis = barChartView.xAxis
        xAxis.drawGridLinesEnabled = false

        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
        
        barChartView.data = data
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(highlight)
        print(entry)
    }
    
    // 获取成员的总点名次数
    func getMemCountName() -> Void {
        if arrClassData.count == 0 {
            return
        }
        let dateStart:String = arrClassData[gIndexClass].dateStart!
        let dateEnd:String = arrClassData[gIndexClass].dateEnd!
        let startTime = try! DateInRegion.init(string: dateStart, format: DateFormat.custom("yyyy-MM-dd"))
        let endTime = try! DateInRegion.init(string: dateEnd, format: DateFormat.custom("yyyy-MM-dd"))

        arrMemNameCount = []
        // 获取所有成员id
        let strMembers:String = arrClassData[gIndexClass].member!
        let membersJsonData = strMembers.data(using: .utf8)
        var arrMembers = JSON(data:membersJsonData!)
        for i in 0..<arrMembers.count {
            let id:Int32 = arrMembers[i]["id"].int32Value
            var one:MemCount=MemCount(name: arrMembers[i]["name"].stringValue, count: 0, id: id)
            arrMemNameCount.append(one)
        }
        arrMemNameCount.sort(by: {$0.id<$1.id})

        // 统计目前时间范围内的 次数
        for i in 0..<arrCallFair.count {
            let one = arrCallFair[i]
            let onedate = DateInRegion.init(absoluteDate: one.date as! Date)
            let id:Int = Int(one.memID)
            // 统计在时间范围内的次数
            if onedate >= startTime && onedate <= endTime {
                // 是选定课程
                if arrClassData[gIndexClass].selCourse == one.course {
                    for j in 0..<arrMemNameCount.count {
                        if arrMemNameCount[j].id == one.memID {
                            arrMemNameCount[j].count = arrMemNameCount[j].count + 1
                            break
                        }
                    }
                }
            }
        }
//        print(arrMemNameCount)
        
        return
    }

    
    
}
