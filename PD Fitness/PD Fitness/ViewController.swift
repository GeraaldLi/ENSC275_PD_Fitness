//
//  ViewController.swift
//  YouTube Example
//
//  Created by Sean Allen on 4/28/17.
//  Copyright © 2017 Sean Allen. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITextFieldDelegate {
    
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addVideoTextField: UITextField!
    
    var videos: [String] = ["eat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    @IBAction func addButtonTapped(_ sender: YTRoundedButton) {
        insertNewVideoTitle()
    }
    
    
    func insertNewVideoTitle() {
        
        if addVideoTextField.text!.isEmpty {
            print("Add Video Text Field is empty")
        }
        
        videos.append(addVideoTextField.text!)
        
        let indexPath = IndexPath(row: videos.count - 1, section: 0)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        
        addVideoTextField.text = ""
        view.endEditing(true)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let videoTitle = videos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        cell.videoTitle.text = videoTitle
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            videos.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}

