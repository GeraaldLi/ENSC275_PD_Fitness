//
//  planedTaskesViewController.swift
//  This is the view of all tasks records
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs: N/A
//
// TODO:
// 1. Implement Search Feature
// 2. Implement File Export Feature

import UIKit
import SafariServices
import FirebaseDatabase

class DataBaseEntriesViewController: UIViewController, UITextFieldDelegate{
    
    //Connect to table view
    @IBOutlet weak var dataBaseEntryTitleTableView: UITableView!
    @IBOutlet weak var databaseEntryTextField: UITextField!
    
    //Declear Variables and update their values latter
        var databaseHandle:DatabaseHandle?
        var ref:DatabaseReference = Database.database().reference()
        var rootDbPath : String = "PDFITNESS_DB"
        
        //String Array used to store data for database titles
        var databaseEntryTitle = [String]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Hiding Empty Rows
            dataBaseEntryTitleTableView.tableFooterView = UIView(frame: CGRect.zero)
            
            //Parse through record tasks database, observe changes when new data entry is added
            databaseHandle = ref.child(rootDbPath).observe(.childAdded, with: { (snapshot) in
                if !snapshot.key.isEmpty {
                    //Update string array
                    self.databaseEntryTitle.append(snapshot.key)
                    //reload data table
                    self.dataBaseEntryTitleTableView.reloadData()
                }
            })
        }
        
        //Connected to Search Button
        @IBAction func dataBaseSearchBtnPressed(_ sender: Any) {
            //Dumy Function, will be implemented next version
            print ("Will search for string entered, will be implemented next version")
            databaseEntryTextField.text = ""
            view.endEditing(true)
        }
    }

    //Extension for UItable view
    extension DataBaseEntriesViewController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return databaseEntryTitle.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let taskTitle = databaseEntryTitle[indexPath.row]
            // Connect to cell with DataBaseEntryCell identifier
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataBaseEntryCell") as! DataBaseEntryCell
            cell.dataBaseEntryTitle.text = taskTitle
            
            return cell
        }
        
        // Set edit permission to be true
        func tableView(_ planedTaskesTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }

        func tableView(_ planedTaskesTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            // delete operation for one datacell
            if editingStyle == .delete {
                //remove corresponding data in string array
                databaseEntryTitle.remove(at: indexPath.row)
                //Update UITableView, will not affect real time database
                planedTaskesTableView.beginUpdates()
                planedTaskesTableView.deleteRows(at: [indexPath], with: .automatic)
                planedTaskesTableView.endUpdates()
            }
        }
    }
