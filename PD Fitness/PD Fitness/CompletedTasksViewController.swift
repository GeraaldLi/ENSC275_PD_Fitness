//
//  planedTaskesViewController.swift
//  This is the view of planed tasks table page, it supports insertion and deletion of data entry of
//  firebase real time database, all data will be represented in a UITableView represented by UITableCells
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs: N/A
//

import UIKit
import FirebaseDatabase
import SafariServices

class CompletedTasksViewController: UIViewController, UITextFieldDelegate{
    
    //Connect to pending tasks table view
    @IBOutlet weak var pendingTasksTableView: UITableView!
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var dateFormString : String = "ID"
    var plannedTasksDbName : String = "plannedTasksDb"
    var completedTasksDbName : String = "completedTasksDb"
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    
    // Stores key and value of a data entry,
    // Folling dual array approch will be switched to dictionary by next version
    // TODO: Switch hashtable or dictionary to store key value pairs
    var keys = [String]()
    var pendingTasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding Empty Rows
        pendingTasksTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Find out current date, where database is created according to loading date
           ref = Database.database().reference()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd"
           dateFormString = dateFormatter.string(from: Date())

           // Set database name for both planned and completed tasks
           plannedTasksDbName = "plannedTasksDb" + dateFormString
           completedTasksDbName = "completedTasksDb" + dateFormString
           
           //Observe Database and refresh table view contents
           databasePath = rootDbPath + "/" + dateFormString + "/" + plannedTasksDbName
           databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
               let valueStr = snapshot.value as? String
               if let appendingValue = valueStr {
                   self.keys.append(snapshot.key)
                   self.pendingTasks.append(appendingValue)
                   self.pendingTasksTableView.reloadData()
               }
           })
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
            databasePath = rootDbPath + "/" + dateFormString + "/" + completedTasksDbName
            ref.child(databasePath).childByAutoId().setValue(pendingTasks[indexPath.row])
            pendingTasks.remove(at: indexPath.row)
            //TODO: Add error handling mechanism
            databasePath = rootDbPath + "/" + dateFormString + "/" + plannedTasksDbName
            ref.child(databasePath).child(keys[indexPath.row]).removeValue()
            pendingTasksTableView.reloadData()
            
//TODO: Add offline support, next version
//Following Code update tableView contents
//            planedTaskesTableView.beginUpdates()
//            planedTaskesTableView.deleteRows(at: [indexPath], with: .automatic)
//            planedTaskesTableView.endUpdates()
        }
    }
}
