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

class UserMineViewController: UIViewController, ChartViewDelegate, IAxisValueFormatter {
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        if arrClassData.count > 0 {
            self.navigationController?.navigationBar.topItem?.title = arrClassData[gIndexClass].classname! + "|" + arrClassData[gIndexClass].selCourse!
        } else {
            TipsSwift.showCenterWithText("请先创建班级!")
        }
        
        chartsGo()
    }
    
    public func stringForValue(_ value: Double, axis: Charts.AxisBase?) -> String
    {
        var months: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return months[Int(value)]
    }
    
    func chartsGo() {
        
        let values: [Double] = [8, 7, 2, 9, 10, 14, 17, 20, 15, 12,
                                13, 8]
        
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
        

        barChartView.xAxis.setValue(8, forKey:"axisLineWidth")
        
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .linear)
        
        barChartView.data = data
    }
    
    override func viewDidLoad() {
        barChartView.xAxis.valueFormatter = self
        
        barChartView.chartDescription?.text = "by 🍉西瓜点名🍉"
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(highlight)
        print(entry)
    }

    
    
}
