//
//  planedTaskesViewController.swift
//  This is the view of planed tasks table page, it supports insertion and deletion of data entry of
//  firebase real time database, all data will be represented in a UITableView represented by UITableCells
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs:
//  1) taskRecordDb missmatch plannedTasksDb is cell is deleted in add task interface
//  How to fix it?
//  track with hash table or dictionary, then remove key value pair in database, it can also fix the loss sync issue when deleting plannedTaskDb
//
//  TODO:
//  1) Change Database layout such that it supports storing user info

import UIKit
import FirebaseDatabase
import SafariServices
import GoogleSignIn
import FirebaseAuth

class PlannedTasksViewController: UIViewController, UITextFieldDelegate{
    
    //Establish Connections
    @IBOutlet weak var plannedTasksTableView: UITableView!  //Connect to table view
    @IBOutlet weak var addTasksTextField: UITextField!      //Connect to text field
    
    //Declear googole user as optional variable
    var googleUser:GIDGoogleUser?
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var dateFormString: String = "ID"
    var plannedTasksDbName: String = "plannedTasksDb"
    var tasksRecordDbName : String = "tasksRecordDb"
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    var taskCountPath: String = "-Task_Count"
    // User ID default to Guest
    var userID: String = "Guest"
    
    // Stores key and value of a data entry,
    // Folling dual array approch will be switched to dictionary by next version
    // TODO: Switch hashtable or dictionary to store key value pairs
    var keys = [String]()
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide Empty Rows of table view
        plannedTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
        
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
        tasksRecordDbName = "tasksRecordDb" + dateFormString
        
        //Observe Database and refresh table view contents
        databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + plannedTasksDbName
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            let valueStr = snapshot.value as? String
            if let appendingValue = valueStr {
                self.keys.append(snapshot.key)
                self.tasks.append(appendingValue)
                self.plannedTasksTableView.reloadData()
            }
        })
    }
    
    //Connected to addButton for planned tasks
    @IBAction func addButtonWasPressed(_ sender: PlannedTasksAddBtn) {
        insertNewTask()
    }
    
    func insertNewTask(){
        // No Tasks Entered, return to main
        if addTasksTextField.text!.isEmpty {
            print("Add New Task Text Field is empty")
            return
        }
        
        // Add task to planned tasks database
        databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + plannedTasksDbName
        incrementTasksCount(dbPath: databasePath, childId: taskCountPath)
        ref.child(databasePath).childByAutoId().setValue(addTasksTextField.text!)
        
        // Add task to full database
        databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + tasksRecordDbName
        incrementTasksCount(dbPath: databasePath, childId: taskCountPath)
        ref.child(databasePath).childByAutoId().setValue(addTasksTextField.text!)
        
        // Clear Test Field after each add
        addTasksTextField.text = ""
        view.endEditing(true)
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

extension PlannedTasksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskTitle = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlannedTasksCell") as! PlannedTasksCell
        cell.taskTitle.text = taskTitle

        return cell
    }
    

    func tableView(_ planedTaskesTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ planedTaskesTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            //TODO: Add error handling mechanism
            databasePath = rootDbPath + "/" + userID + "/" + dateFormString + "/" + plannedTasksDbName
            decrementTasksCount(dbPath: databasePath, childId: taskCountPath)
            ref.child(databasePath).child(keys[indexPath.row]).removeValue()
            plannedTasksTableView.reloadData()
            }
        }
}
