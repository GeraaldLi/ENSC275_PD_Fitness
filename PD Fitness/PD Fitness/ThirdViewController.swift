//
//  ThirdViewController.swift
//  PD Fitness Tracking Page
//
//  Created by Gerald Li  on 2019-10-29.
//  Copyright © 2019 Gerald Li . All rights reserved.
//

import UIKit
import FirebaseDatabase

class ThirdViewController: UIViewController {
    
    var databaseHandle:DatabaseHandle?
    var readData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let ref = Database.database().reference()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.string(from: Date())
        
        //create a new key
        //eg
        ref.child(dateFromString).setValue("day")
        ref.child(dateFromString).setValue(["name": "a", "role":"b", "age":20])
        
        //Read data
//        ref.child(dateFromString).observeSingleEvent(of: .value)
//            { (snapshot) in
//                let readData = snapshot.value as? [String:Any]
//        }
        
        //Retrieve data from a specific date and listen for changes
        
        databaseHandle = ref.child(dateFromString).observe(.childAdded, with: { (snapshot) in
            // Code to execute when a chld is added under dateFromString
            // Take the value from the snapshot and added it to the readData array
            // this function will parse through the data tree and lisen to changes
            //print(snapshot)
            //self.readData.append("")
        })
        
        
        print("formated is", dateFromString)
        //print("readData is", readData)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
