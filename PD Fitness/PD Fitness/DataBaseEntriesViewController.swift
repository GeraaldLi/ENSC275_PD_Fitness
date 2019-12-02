//
//  planedTaskesViewController.swift
//  This is the view of all tasks records
//
//  Team: PD Fitness(Team 7)
//  Programmers: Gerald Li
//  Known Bugs: N/A
//

import UIKit
import SafariServices
import FirebaseDatabase
import GoogleSignIn
import FirebaseAuth

class DataBaseEntriesViewController: UIViewController, UITextFieldDelegate{
    
    //Connect to table view
    @IBOutlet weak var dataBaseEntryTitleTableView: UITableView!
    @IBOutlet weak var databaseEntryTextField: UITextField!
    
    //Declear googole user as optional variable
    var googleUser:GIDGoogleUser?
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var databasePath : String = "dateFormString/.."
    var rootDbPath : String = "PDFITNESS_DB"
    // User ID default to Guest
    var userID: String = "Guest"
    
    //String Array used to store data for database titles
    var databaseEntryTitle = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hiding Empty Rows
        dataBaseEntryTitleTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        //Initialize googleUser
        updateUserId()
        
        //observe record tasks database, update table
        observeRecordTasksDb_updateTable()
    }
    
    //Connected to Search Button
    @IBAction func dataBaseSearchBtnPressed(_ sender: Any) {
        searchKeyWord()
    }

    // Export Button Pressed
    @IBAction func ExportBtnPressed(_ sender: UIButton!) {
        exportDb(sender)
    }
    
    //update user ID
    func updateUserId(){
        if GIDSignIn.sharedInstance()!.currentUser != nil {
                   googleUser = GIDSignIn.sharedInstance()!.currentUser
                   userID = googleUser!.profile.name
       }
    }
    
    //observe record tasks database, update table
    func observeRecordTasksDb_updateTable() {
        databasePath = rootDbPath + "/" + userID
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            if !snapshot.key.isEmpty {
                //Update string array
                self.databaseEntryTitle.append(snapshot.key)
                //reload data table
                self.dataBaseEntryTitleTableView.reloadData()
            }
        })
    }
    
    //perform search
    func searchKeyWord() {
        self.databaseEntryTitle.removeAll()
        dataBaseEntryTitleTableView.reloadData()
        
        let text: String = self.databaseEntryTextField.text!
        databasePath = rootDbPath + "/" + userID
        databaseHandle = ref.child(databasePath).observe(.childAdded, with: { (snapshot) in
            if !snapshot.key.isEmpty && snapshot.key == text {
                //Update string array
                self.databaseEntryTitle.append(snapshot.key)
                //reload data table
                self.dataBaseEntryTitleTableView.reloadData()
            }
        })
        databaseEntryTextField.text = ""
        view.endEditing(true)
    }
    
    //perform export
    func exportDb(_ sender: UIButton) {
        var URLString = "https://fir-pdfitness.firebaseio.com/PDFITNESS_DB"
        URLString = URLString + "/" + userID
        URLString = URLString + "/" + databaseEntryTitle[sender.tag]
        URLString = URLString + ".json?print=pretty;download=PDFitnessExport.txt"
        
        let ExportURLString = URLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        print(ExportURLString!)
        
        guard let url = URL(string: ExportURLString!) else {return}
        
        UIApplication.shared.open(url);
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
        cell.dataBaseEntryExpBtn.tag = indexPath.row
        
        
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
