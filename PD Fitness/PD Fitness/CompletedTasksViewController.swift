//
//  planedTaskesViewController.swift
//  This is the view of planed tasks table page, it supports insertion and deletion of data entry of
//  firebase real time database, all data will be represented in a UITableView represented by UITableCells
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs: N/A
//
//  TODO:
//  1) Change Database layout such that it supports storing user info

import UIKit
import FirebaseDatabase
import SafariServices
import GoogleSignIn
import FirebaseAuth

class CompletedTasksViewController: UIViewController, UITextFieldDelegate{
    
    //Connect to pending tasks table view
    @IBOutlet weak var pendingTasksTableView: UITableView!
    
    //Declear googole user as optional variable
    var googleUser:GIDGoogleUser?
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var dateFormString : String = "ID"
    var plannedTasksDbName : String = "plannedTasksDb"
    var completedTasksDbName : String = "completedTasksDb"
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    var taskCountPath: String = "-Task_Count"
    // User ID default to Guest
    var userID: String = "Guest"
    
    // Stores key and value of a data entry,
    var keys = [String]()
    var pendingTasks = [String]()
    
    // Completed Tasks Count
    var taskCount_completed: Int = 0
    var taskCount_planned: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding Empty Rows
        pendingTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Initialize googleUser, update UserIDLable
        if GIDSignIn.sharedInstance()!.currentUser != nil {
            googleUser = GIDSignIn.sharedInstance()!.currentUser
            userID = googleUser!.profile.name
            print ("userId is", userID)
        }
            
        // Find out current date, where database is created according to loading date
           ref = Database.database().reference()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           dateFormString = dateFormatter.string(from: Date())

           // Set database name for both planned and completed tasks
           plannedTasksDbName = "plannedTasksDb" + dateFormString
           completedTasksDbName = "completedTasksDb" + dateFormString
           
           //Observe Database and refresh table view contents
           databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + plannedTasksDbName
           databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
               let valueStr = snapshot.value as? String
               if let appendingValue = valueStr {
                   self.keys.append(snapshot.key)
                   self.pendingTasks.append(appendingValue)
                   self.pendingTasksTableView.reloadData()
               }
           })
        }
    
    func incrementTasksCount(dbPath: String, childId: String) {
        ref.child(dbPath).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(childId){
                var currentTaskCount:Int = 0
                self.ref.child(dbPath).child(childId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? Int
                if value != nil {
                    currentTaskCount = value! + 1
                    self.ref.child(dbPath).child(childId).setValue(currentTaskCount)
                }
                }) { (error) in
                    print("Increment TasksCount, Error occured during read task count", dbPath)
                    return
                }
            }
            else{
                self.ref.child(dbPath).child(childId).setValue(1)
            }
        }){
            (error) in
            print("Increment TasksCount, Error occured during check task count existence", dbPath)
        }
    }
    
    func decrementTasksCount(dbPath: String, childId: String) {
        ref.child(dbPath).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(childId){
                var currentTaskCount:Int = 0
                self.ref.child(dbPath).child(childId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? Int
                if value != nil && value! > 0 {
                    currentTaskCount = value! - 1
                    self.ref.child(dbPath).child(childId).setValue(currentTaskCount)
                }
                else{
                    print ("Decrement TasksCount, TaskCount is 0, do nothing, early return")
                    return
                }
                }) { (error) in
                    print("Decrement TasksCount, Error occured during read task count", dbPath)
                    return
                }
            }
        }) {
            (error) in
            print("Decrement TasksCount, Error occured during check task count existence", dbPath)
        }
    }
}

extension CompletedTasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskTitle = pendingTasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingTaskCell") as! PendingTaskCell
        cell.PendingTaskTitle.text = taskTitle

        return cell
    }
    

    func tableView(_ planedTaskesTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ planedTaskesTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            // Add delated entry to completed List of tasks in database
            self.taskCount_completed += 1
            print("current completed task count:", self.taskCount_completed)
            
            //Define database path
            databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + completedTasksDbName
            incrementTasksCount(dbPath: databasePath, childId: taskCountPath)
            //Add value
            ref.child(databasePath).childByAutoId().setValue(pendingTasks[indexPath.row])
            //clear string array
            pendingTasks.remove(at: indexPath.row)
            
            //TODO: Add error handling mechanism
            databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + plannedTasksDbName
            decrementTasksCount(dbPath: databasePath, childId: taskCountPath)
            ref.child(databasePath).child(keys[indexPath.row]).removeValue()
            pendingTasksTableView.reloadData()
        }
    }
}
