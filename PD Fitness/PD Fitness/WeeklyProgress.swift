//
//  WeeklyProgress.swift
//  This view displays daily progress in the form of charts
//
//  Team: PD Fitness(Team 7)
//  Programmers: Andrew Chen
//  Known Bugs:
//  1) N/A
//
// TODO:
// 1) Add firebase data
// 2) Format charts
// 3)

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Charts

class WeeklyProgress: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //currently using dummy data
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
                
        setChart(dataPoints: months, values: unitsSold)
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var BarChartView: BarChartView!      //Bar chart outlet
    
    var months: [String]!
    
    func setChart(dataPoints: [String], values: [Double])
    {
        BarChartView.noDataText = "There is currently have no data to display";      //message displayed when no chart data is available
        
        var dataEntries: [BarChartDataEntry] = []                                    //array of bar chart entries
                
        for i in 0..<dataPoints.count {
            //loops for the amount of data points
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])            //sets relationship between the x and y values
            dataEntries.append(dataEntry)                                            //adds the data entries into the dataEntries array
        }
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")       //putting labels on the data entries
        let chartData = BarChartData(dataSet: chartDataSet)                                 //puts the data into chartData
        BarChartView.data = chartData                                                       //displays chartData onto BarChartView
    
        
        //Chart Formatting
        BarChartView.chartDescription?.text = ""                       //removes description text
        //sets the colour scheme for the bars
        //repeats the same two colours since only two are set
        chartDataSet.colors = [UIColor(red: 100/255, green: 200/255, blue: 150/255, alpha: 1),
                               UIColor(red: 50/255, green: 150/255, blue: 210/255, alpha:1)]
        BarChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)       //background colour
        BarChartView.animate(xAxisDuration: 2.5, yAxisDuration: 2.5, easingOption: .easeInQuart)
        BarChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom               //sets x-axis labels to the bottom
        
    }
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
           
           var values : [String]
           required init (values : [String]) {
               self.values = values
               super.init()
           }
    
           func stringForValue(_ value: Double, axis: AxisBase?) -> String {
               return values[Int(value)]
           }
       }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
