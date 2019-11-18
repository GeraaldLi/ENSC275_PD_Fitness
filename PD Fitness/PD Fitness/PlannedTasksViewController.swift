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

class PlannedTasksViewController: UIViewController, UITextFieldDelegate{
    
    //Establish Connections
    @IBOutlet weak var plannedTasksTableView: UITableView!  //Connect to table view
    @IBOutlet weak var addTasksTextField: UITextField!      //Connect to text field
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var dateFormString: String = "ID"
    var plannedTasksDbName: String = "plannedTasksDb"
    var tasksRecordDbName : String = "tasksRecordDb"
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    
    // Stores key and value of a data entry,
    // Folling dual array approch will be switched to dictionary by next version
    // TODO: Switch hashtable or dictionary to store key value pairs
    var keys = [String]()
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide Empty Rows of table view
        plannedTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Find out current date, where database is created according to loading date
        ref = Database.database().reference()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormString = dateFormatter.string(from: Date())
        
        // Set database name for both planned and completed tasks
        plannedTasksDbName = "plannedTasksDb" + dateFormString
        tasksRecordDbName = "tasksRecordDb" + dateFormString
        
        //Observe Database and refresh table view contents
        databasePath = rootDbPath + "/" + dateFormString + "/" + plannedTasksDbName
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
        databasePath = rootDbPath + "/" + dateFormString + "/" + plannedTasksDbName
        ref.child(databasePath).childByAutoId().setValue(addTasksTextField.text!)
        databasePath = rootDbPath + "/" + dateFormString + "/" + tasksRecordDbName
        ref.child(databasePath).childByAutoId().setValue(addTasksTextField.text!)
        
        // Clear Test Field after each add
        addTasksTextField.text = ""
        view.endEditing(true)
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
            databasePath = rootDbPath + "/" + dateFormString + "/" + plannedTasksDbName
            ref.child(databasePath).child(keys[indexPath.row]).removeValue()
            plannedTasksTableView.reloadData()
            }
        }
    //TODO: Add offline support, next version
    //Following Code update tableView contents
    //            planedTaskesTableView.beginUpdates()
    //            planedTaskesTableView.deleteRows(at: [indexPath], with: .automatic)
    //            planedTaskesTableView.endUpdates()
}
