//
//  TrackingViewController.swift
//  This view is the main page of tracking feature
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs: Sometimes Progess Bar missmatches planStatusLable's contents at edge case (pending task = 0)
//

import UIKit
import FirebaseDatabase
import SafariServices


class TrackingViewController: UIViewController {
    
     //Establish Connections
    //TODO: Link data to tasks tables, version 2
    // @IBOutlet weak var trackingPageCompletedTasksTable: UITableView!
    // @IBOutlet weak var trackingPagePendingTasksTable: UITableView!
    @IBOutlet weak var accomplishLable: UILabel!
    @IBOutlet weak var planStatusLable: UILabel!
    @IBOutlet weak var dailyProgressIndicator: UIProgressView!
    
   //Counters used for progress bar value calculation
    var compltedTasksCounter:Int = 0
    var totalTasksCounter:Int = 0

    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    
    //Declear strings for database pathes with default values, they will be overwrite latter
    var dateFormString: String = "ID"
    var plannedTasksDbName: String = "plannedTasksDb"
    var completedTasksDbName: String = "completedTasksDb"
    var tasksRecordDbName : String = "tasksRecordDb"
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize progressbar value
        dailyProgressIndicator.progress = 0
        
        //Initialize table value
        accomplishLable.text = "Archive tasks by clicking Archive Task button =>"
        planStatusLable.text = "Add new tasks by clicking Add New Task button =>"
        
        //Find out current date, where database is created according to loading date
        ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormString = dateFormatter.string(from: Date())
        
        //Set tasks Record database respect to date
        tasksRecordDbName = "tasksRecordDb" + dateFormString
        
        //Initialize databasePath
        databasePath = rootDbPath + "/" + dateFormString + "/" + tasksRecordDbName
        
        //Parse through record tasks database, observe changes when new data entry is added
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            // Convert snapshot value to string
            let valueStr = snapshot.value as? String
            
            //Update progressbar value when snapshot value is not empty(nil)
            if valueStr != nil {
                self.totalTasksCounter += 1
                if self.totalTasksCounter > 0 {
                    // Convert to Float type
                    let progressF = Float(self.compltedTasksCounter) / Float(self.totalTasksCounter)
                    // Update Progress Bar Value
                    self.dailyProgressIndicator.progress = progressF
                    // Update Label texts
                    self.updatePlanStatusLableTxt()
                }
                else
                {
                    self.dailyProgressIndicator.progress = 0
                }
            }
        })
        
        //Set completed tasks database respect to date
        completedTasksDbName = "completedTasksDb" + dateFormString
        
        //Initialize databasePath
        databasePath = rootDbPath + "/" + dateFormString + "/" + completedTasksDbName
        //Parse through completed tasks database, observe changes when new data entry is added
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if valueStr != nil {
                self.compltedTasksCounter += 1
                if self.totalTasksCounter > 0 {
                    // Convert to Float type
                    let progressF = Float(self.compltedTasksCounter) / Float(self.totalTasksCounter)
                    // update progress bar value
                    self.dailyProgressIndicator.progress = progressF
                    // update accomplishLable's texts
                    self.updateAccomplishLableTxt()
                    // update planStatusLable's texts
                    self.updatePlanStatusLableTxt()
                }
                else
                {
                    self.dailyProgressIndicator.progress = 0
                }
            }
        })
        
    }
    
    func updateAccomplishLableTxt(){
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
    }
    
    // update planStatusLable's texts
    func updatePlanStatusLableTxt(){
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
    }
}


