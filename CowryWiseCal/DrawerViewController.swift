//
//  DrawerViewController.swift
//  CowryWiseCal
//
//  Created by Peter Oriola on 19/07/2019.
//  Copyright © 2019 Peter Oriola. All rights reserved.
//

import UIKit
import Charts




class DrawerViewController: UIViewController {
   
    //Data Types
    var dayStats = ""
    var dayData = LineChartData.self

    //OutLets from the ViewController
    @IBOutlet weak var graphView: LineChartView!
    @IBOutlet weak var handleAreaView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateGraphData()
        graphView.chartDescription?.text = "Rates"
        
        let set = LineChartDataSet.self
        let set1 = LineChartData(dataSet: dayStats as? IChartDataSet)
        graphView.data = set1
        
    }


    func updateGraphData(_ count : Int = 0) {
        
        
    }
    
}
