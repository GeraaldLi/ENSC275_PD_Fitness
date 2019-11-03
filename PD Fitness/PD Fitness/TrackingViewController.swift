//
//  SecondViewController.swift
//  PD Fitness
//
//  Created by Gerald Li  on 2019-10-17.
//  Copyright © 2019 Gerald Li . All rights reserved.
//

import UIKit
import FirebaseDatabase
import SafariServices


class TrackingViewController: UIViewController {
    
    //Establish Connections
//    @IBOutlet weak var trackingPageCompletedTasksTable: UITableView!
//    @IBOutlet weak var trackingPagePendingTasksTable: UITableView!
    @IBOutlet weak var accomplishLable: UILabel!
    @IBOutlet weak var planStatusLable: UILabel!
    @IBOutlet weak var dailyProgressIndicator: UIProgressView!
    
    var compltedTasksCounter:Int = 0
    var totalTasksCounter:Int = 0
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var dateFormString: String = "ID"
    var plannedTasksDbName: String = "plannedTasksDb"
    var completedTasksDbName: String = "completedTasksDb"
    var tasksRecordDbName : String = "tasksRecordDb"
    
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyProgressIndicator.progress = 0
        
        // Find out current date, where database is created according to loading date
        ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormString = dateFormatter.string(from: Date())
        
        // Set database name for both planned and completed tasks
        tasksRecordDbName = "tasksRecordDb" + dateFormString
        
        //Parse through plannedTaskDbName database
        databasePath = rootDbPath + "/" + dateFormString + "/" + tasksRecordDbName
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if let appendingValue = valueStr {
                self.totalTasksCounter += 1
                if self.totalTasksCounter > 0 {
                    let progressF = Float(self.compltedTasksCounter) / Float(self.totalTasksCounter)
                    self.dailyProgressIndicator.progress = progressF
                    if (self.totalTasksCounter - self.compltedTasksCounter) > 1 {
                        self.planStatusLable.text = String(self.totalTasksCounter - self.compltedTasksCounter) + " tasks are pending"
                    }
                    else if (self.totalTasksCounter - self.compltedTasksCounter) == 0
                    {
                        self.planStatusLable.text = " All tasks are accomplished! Well Done!"
                    }
                    else
                    {
                        self.planStatusLable.text = String(self.totalTasksCounter - self.compltedTasksCounter) + " task remaining!"
                    }
                    
                    print(appendingValue, progressF)
                }
                else
                {
                    self.dailyProgressIndicator.progress = 0
                }
            }
        })
        
        completedTasksDbName = "completedTasksDb" + dateFormString
        //Parse through plannedTaskDbName database
        databasePath = rootDbPath + "/" + dateFormString + "/" + completedTasksDbName
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if let appendingValue = valueStr {
                self.compltedTasksCounter += 1
                if self.totalTasksCounter > 0 {
                    let progressF = Float(self.compltedTasksCounter) / Float(self.totalTasksCounter)
                    self.dailyProgressIndicator.progress = progressF
                    if self.compltedTasksCounter > 1 {
                        self.accomplishLable.text = String(self.compltedTasksCounter) + " tasks have been completed! :)"
                    }
                    else if self.compltedTasksCounter == 0
                    {
                        self.accomplishLable.text = " No task has been done, lets start :)"
                    }
                    else
                    {
                        self.accomplishLable.text = String(self.compltedTasksCounter) + " task has been completed! :)"
                    }
                    
                    if (self.totalTasksCounter - self.compltedTasksCounter) > 1 {
                        self.planStatusLable.text = String(self.totalTasksCounter - self.compltedTasksCounter) + " tasks are pending"
                    }
                    else if (self.totalTasksCounter - self.compltedTasksCounter) == 0
                    {
                        self.planStatusLable.text = " All tasks are accomplished! Well Done!"
                    }
                    else
                    {
                        self.planStatusLable.text = String(self.totalTasksCounter - self.compltedTasksCounter) + " task remaining!"
                    }
                    
                    print(appendingValue, progressF)
                }
                else
                {
                    self.dailyProgressIndicator.progress = 0
                }
            }
        })
        
    }


}

