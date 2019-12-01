//
//  WeeklyProgress.swift
//  This view displays daily progress in the form of charts
//
//  Team: PD Fitness(Team 7)
//  Programmers: Andrew Chen
//  Known Bugs:
//  1) Chart x-axis starts too high
//
// TODO:
// 1) Add firebase data
// 2) Format charts
// 3)

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Charts
import GoogleSignIn




class WeeklyProgress: UIViewController {

    // @IBOutlet weak var BarChartView: BarChartView!      //Bar chart outlet
    //@IBOutlet weak var BarChartView: UIView!
    
    @IBOutlet weak var BarChartView: BarChartView!
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    
    //Declear googole user as optional variable
    var googleUser:GIDGoogleUser?
    // User ID default to Guest
    var userID: String = "Guest"
    
    
    
    //Declare strings for database paths with default values, they will be overwrite latter
    var dateFormString: [String] = []
    var plannedTasksDbName: String = "plannedTasksDb"
    var completedTasksDbName: [String] = []
    var tasksRecordDbName : [String] = []
    var databasePath : String = "dateFormString/.."
    var taskPath : [String] = []
    var completePath : [String] = []
    var rootDbPath : String = "PDFITNESS_DB"

    var dataEntries: [BarChartDataEntry] = []       //empty array for storing completed task data
    var dataEntries2: [BarChartDataEntry] = []      //empty array for storing total task data
    

    
    
    var pastDays: [Date?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...6      // Initilizing Array to size 7 for past week
        {
            dataEntries.append(BarChartDataEntry(x: 0, y: 0))
            dataEntries2.append(BarChartDataEntry(x: 0, y: 0))
        }
        
        
        //Initialize googleUser, update UserIDLable
        if GIDSignIn.sharedInstance()!.currentUser != nil {
            googleUser = GIDSignIn.sharedInstance()!.currentUser
            userID = googleUser!.profile.name
            print ("userId is", userID)
        }
        
        ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate = Date()
        
        var dateComponent = DateComponents()
            
        //loop for grabbing the completed task number and total task number
        
        for j in 0 ... 6
        {

            let i = -j
            dateComponent.day = i
            pastDays.append(Calendar.current.date(byAdding: dateComponent, to: currentDate))
            dateFormString.append(dateFormatter.string(from: pastDays[j]!))
 
            //
            //grabbing count of completed tasks
            completedTasksDbName.append("completedTasksDb" + dateFormString[j])
            completePath.append(rootDbPath + "/" + userID + "/" + dateFormString[j] + "/" + completedTasksDbName[j])
            print(dateFormString[j])
            ref.child(completePath[j]).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.hasChild("-Task_Count")
                {
                    print("---Random----")
                    self.ref.child(self.completePath[j]).child("-Task_Count").observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as! Double
                        
                        let dataEntry = BarChartDataEntry(x: Double(j), y: value)
                        self.dataEntries.insert(dataEntry, at:j)
                        print("Adding ", value , "to Data Entry", "for date ", self.dateFormString[j])
                        })
                }
                else
                {
                    let dataEntry = BarChartDataEntry(x: Double(j), y: 0)
                    self.dataEntries.insert(dataEntry, at:j)
                    print("Adding 0 to Data Entry", "for date ", self.dateFormString[j])
                  //  self.foo(index: 1)
                }

                   })
            //
            //grabbing count of total tasks
            tasksRecordDbName.append("tasksRecordDb" + dateFormString[j])
            taskPath.append(rootDbPath + "/" + userID + "/" + dateFormString[j] + "/" + tasksRecordDbName[j])
            ref.child(taskPath[j]).observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.hasChild("-Task_Count")
                {
                    self.ref.child(self.taskPath[j]).child("-Task_Count").observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! Double
                    let dataEntry2 = BarChartDataEntry(x: Double(j), y: value)
                        self.dataEntries2.insert(dataEntry2, at:j)
                        print("Adding ", value , "to Data Entry2", "for date ", self.dateFormString[j])
                 //   self.foo(index: 1)
                        self.setChart2(Entries: self.dataEntries, Entries2: self.dataEntries2)
                    })
                }
                else
                {
                    let dataEntry2 = BarChartDataEntry(x: Double(j), y: 0)
                    self.dataEntries2.insert(dataEntry2, at:j)
                    //self.foo(index:1)
                    print("Adding 0 to Data Entry2")
                    self.setChart2(Entries: self.dataEntries, Entries2: self.dataEntries2)
                }
                    })

        }

        setChart(Date: self.dateFormString)
    }
    
    func setChart2(Entries: [ChartDataEntry]?, Entries2: [ChartDataEntry]?)
    {
        let chartDataSet = BarChartDataSet(entries: Entries, label: "Completed Tasks")
        let chartDataSet1 = BarChartDataSet(entries: Entries2, label: "Total Tasks")


        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3

        let start = 0


        chartData.barWidth = barWidth;
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
 
        BarChartView.xAxis.axisMaximum = Double(start) + gg * 8

        chartData.groupBars(fromX: Double(start), groupSpace: groupSpace, barSpace: barSpace)
        
        
        BarChartView.notifyDataSetChanged()
        BarChartView.setVisibleXRangeMaximum(2)
        BarChartView.moveViewToX(0)
        
        //Set BarChart Colour
        chartDataSet.colors = [UIColor(red: 100/255, green: 200/255, blue: 150/255, alpha: 1)]
        chartDataSet1.colors = [UIColor(red: 50/255, green: 150/255, blue: 210/255, alpha:1)]
        
        BarChartView.data = chartData
    }
    
    var months: [String]!
    
    func setChart(Date: [String])
    {
        //Chart Formatting
        BarChartView.chartDescription!.text = " "                       //removes description text

        BarChartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)       //background colour
        BarChartView.animate(xAxisDuration: 2.5, yAxisDuration: 2.5, easingOption: .easeInQuart)

        
        let xaxis = BarChartView.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.dateFormString)
        let yaxis = BarChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
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


}
