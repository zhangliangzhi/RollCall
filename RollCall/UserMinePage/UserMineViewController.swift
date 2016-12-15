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

class UserMineViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        if arrClassData.count > 0 {
            self.navigationController?.navigationBar.topItem?.title = arrClassData[gIndexClass].classname! + "|" + arrClassData[gIndexClass].selCourse!
        } else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        
        chartsGo()
    }
    
    func chartsGo() {
        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                                99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
        
        var entries: [ChartDataEntry] = Array()
        for (i, value) in values.enumerated()
        {
            entries.append( BarChartDataEntry(x: Double(i), y: value) )
        }
        
        let dataSet: BarChartDataSet = BarChartDataSet(values: entries, label: "点名次数")

        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.85
        //        chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        dataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        
        barChartView.backgroundColor = NSUIColor.clear
        barChartView.xAxis.labelPosition = .bottom
        let xAxis = barChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
        
        barChartView.data = data
    }
    
    override func viewDidLoad() {
        
        barChartView.chartDescription?.text = "by 🍉西瓜点名🍉"

    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(highlight)
        print(entry)
    }

    
    
}
