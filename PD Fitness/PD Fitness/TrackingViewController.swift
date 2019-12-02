//
//  TrackingViewController.swift
//  This view is the main page of tracking feature
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs:
//  1) Two identical values in database have risks to be deleted at the same time
//  2) Lable out off sync in edge cases
//  3) Log out is done locally, need to implement a global logout function in AppDelegate next version
//  4) trackingPageCompletedTasksTable does not load properly upon first entering of view
//
// TODO:
// 1) Change Database layout such that it supports storing user info
// 2) Fix bugs

import UIKit
import FirebaseDatabase
import SafariServices
import GoogleSignIn
import FirebaseAuth

class TrackingViewController: UIViewController {
    
    //Establish Connections
    @IBOutlet weak var accomplishLable: UILabel!
    @IBOutlet weak var planStatusLable: UILabel!
    @IBOutlet weak var dailyProgressIndicator: UIProgressView!
    @IBOutlet weak var trackingPageCompletedTasksTable: UITableView!
    @IBOutlet weak var trackingPagePendingTasksTable: UITableView!
    @IBOutlet weak var UserIDLable: UILabel!
    @IBOutlet weak var logOutBtn: LogOutButton!
    
    //instance of appDelegate
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    //tableId
    var completedTasksTableID:CGFloat = 0.95
    var pendingTasksTableID:CGFloat = 0.89

    //Counters used for progress bar value calculation
    var compltedTasksCounter:Int = 0
    var totalTasksCounter:Int = 0
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    
    //Declear googole user as optional variable
    var googleUser:GIDGoogleUser?
    
    //Declear strings for database pathes with default values, they will be overwrite latter
    var dateFormString: String = "ID"
    var plannedTasksDbName: String = "plannedTasksDb"
    var completedTasksDbName: String = "completedTasksDb"
    var tasksRecordDbName : String = "tasksRecordDb"
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    
    // User ID default to Guest
    var userID: String = "Guest"
    
    // Stores key and value of a data entry,
    // TODO: Switch hashtable or dictionary to store key value pairs
    var tasks_completed = [String]()
    var tasks_pending = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hiding Empty Rows
        trackingPageCompletedTasksTable.tableFooterView = UIView(frame: CGRect.zero)
        trackingPagePendingTasksTable.tableFooterView = UIView(frame: CGRect.zero)
        
        //Initialize googleUser, update UserIDLable
        if GIDSignIn.sharedInstance()!.currentUser != nil {
            googleUser = GIDSignIn.sharedInstance()!.currentUser
            UserIDLable.text = googleUser?.profile.name
            userID = googleUser!.profile.name
            print ("userId is", userID)
            logOutBtn.isEnabled = true
            logOutBtn.isHidden = false
        }
        else{
            UserIDLable.text = " Guest "
            logOutBtn.isEnabled = false
            logOutBtn.isHidden = true
        }
        
        //Initialize table IDs
        trackingPageCompletedTasksTable.alpha = completedTasksTableID
        trackingPagePendingTasksTable.alpha = pendingTasksTableID
        
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
        databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + tasksRecordDbName
        print ("db path:", databasePath)
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
        databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + completedTasksDbName
        //Parse through completed tasks database, observe changes when new data entry is added
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if let appendingValue = valueStr {
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
                    
                    // Update Table View
                    // update string array
                    self.tasks_completed.append(appendingValue)
                    // reload data tables
                    self.trackingPageCompletedTasksTable.reloadData()
                }
                else
                {
                    self.trackingPageCompletedTasksTable.reloadData()
                    self.dailyProgressIndicator.progress = 0
                }
            }
        })
        //Set completed tasks database respect to date
        plannedTasksDbName = "plannedTasksDb" + dateFormString
        //Initialize databasePath
        databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + plannedTasksDbName
        //Parse through pending tasks database, observe changes when new data entry is added
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if let appendingValue = valueStr {
                    //Update Table View
                    // update string array
                    self.tasks_pending.append(appendingValue)
                    // reload data table
                    self.trackingPagePendingTasksTable.reloadData()
                }
        })
        databaseHandle = ref.child(databasePath).observe(.childRemoved, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if let removedValue = valueStr {
                    //Update Table View
                    self.tasks_pending.removeAll {$0 == removedValue}
                    // reload data table
                    self.trackingPagePendingTasksTable.reloadData()
                }
        })
    
    }
    
    //Log off user
    @IBAction func logOutBtnPressed(_ sender: Any) {
        //only log off when user exists
        if googleUser != nil {
            //appDelegate!.googleSignOff()
            do {
                //sign off both firebase and google
                try Auth.auth().signOut()
                GIDSignIn.sharedInstance().signOut()
                
                //check log off status
                if GIDSignIn.sharedInstance()!.currentUser != nil {
                    print ("------- Logoff Failed-----")
                }
                else{
                    self.viewDidLoad()
                    trackingPageCompletedTasksTable.reloadData()
                    trackingPagePendingTasksTable.reloadData()
                    
                }
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        else {
            return
        }
    }
    
    //Update accomplish Lable texts
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
    
    //Check current user, default to "Guest"
    func checkCurrentUer() -> String {
        var currentUSer: String = "Guest"
        var currentGoogleUser:GIDGoogleUser?
        if GIDSignIn.sharedInstance()!.currentUser != nil {
            currentGoogleUser = GIDSignIn.sharedInstance()!.currentUser
            currentUSer = currentGoogleUser!.profile.name
        }
        return currentUSer
    }
    
}

extension TrackingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.alpha > 0.9 && tableView.alpha < 1.0 { //trackingPageCompletedTasksTable
            return tasks_completed.count
        }
        else if tableView.alpha < 0.9 { //trackingPagePendingTasksTable
            return tasks_pending.count;
        }
        else {
            return 0;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.alpha > 0.9 && tableView.alpha < 1.0 { //trackingPageCompletedTasksTable
            let taskTitle_c = tasks_completed[indexPath.row]
            let cell_c = tableView.dequeueReusableCell(withIdentifier: "TrackingCellCompleted") as! TrackingTableViewCellCompletedTableViewCell
            cell_c.trackingCellCompleted.text = taskTitle_c
            return cell_c
        }
        else if tableView.alpha < 0.9 { //trackingPagePendingTasksTable
            let taskTitle_p = tasks_pending[indexPath.row]
            let cell_p = tableView.dequeueReusableCell(withIdentifier: "TrackingCellPending") as! TrackingTableViewCellPendingTableViewCell
            cell_p.trackingLablePending.text = taskTitle_p
            return cell_p
        }
        else { //exception, return empty cell object
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ planedTaskesTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


