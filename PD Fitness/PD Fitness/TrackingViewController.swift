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
    var remainingTasksCounter:Int = 0
    
    //Declear Variables and update their values latter
    var databaseHandle:DatabaseHandle?
    var ref:DatabaseReference = Database.database().reference()
    var dateFormString: String = "ID"
    var plannedTasksDbName: String = "plannedTasksDb"
    var completedTasksDbName: String = "completedTasksDb"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

