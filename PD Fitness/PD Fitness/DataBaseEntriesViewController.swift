//
//  planedTaskesViewController.swift
//  PD Fitness
//
//  Created by Gerald Li on 2019-11-02.
//  Copyright © 2019 Gerald Li . All rights reserved.
//

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
    
    var databaseEntryTitle = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // After Loading
        
        // Hiding Empty Rows
        dataBaseEntryTitleTableView.tableFooterView = UIView(frame: CGRect.zero)
        rootDbPath = "PDFITNESS_DB"
        databaseHandle = ref.child(rootDbPath).observe(.childAdded, with: { (snapshot) in
            if !snapshot.key.isEmpty {
                self.databaseEntryTitle.append(snapshot.key)
                self.dataBaseEntryTitleTableView.reloadData()
            }
        })
        
    }
    
    @IBAction func dataBaseSearchBtnPressed(_ sender: Any) {
        //Dumy Function, will be implemented next version
        print ("Will search for string entered, will be implemented next version")
        databaseEntryTextField.text = ""
        view.endEditing(true)
    }
}

extension DataBaseEntriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return databaseEntryTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskTitle = databaseEntryTitle[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataBaseEntryCell") as! DataBaseEntryCell
        cell.dataBaseEntryTitle.text = taskTitle

        return cell
    }
    

    func tableView(_ planedTaskesTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ planedTaskesTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            databaseEntryTitle.remove(at: indexPath.row)

            planedTaskesTableView.beginUpdates()
            planedTaskesTableView.deleteRows(at: [indexPath], with: .automatic)
            planedTaskesTableView.endUpdates()
        }
    }
}
