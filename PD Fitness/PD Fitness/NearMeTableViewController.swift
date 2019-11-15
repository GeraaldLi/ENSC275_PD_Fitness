//
//  NearMeTableViewController.swift
//  PD Fitness
//
//  Created by Reed Lu on 2019-11-12.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import Foundation
import UIKit

class NearMeTableViewController : UITableViewController {
    
    //define the search categories
    var categoryPlaces = ["Hospital","Fitness Center","Clinic"]
    
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populatepuCategoriesForPlaces()
        self.tableView.reloadData()
    }
    
    //define number of selections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearMeTableViewCell", for: indexPath) as! NearMeTableViewCell
        
        let place = self.places[indexPath.row]
        
        cell.titleLabel.text = place.title
        return cell
    }
    
    //define segue properties
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("No row selected")
        }
        
        let place = self.places[indexPath.row]
        let containerViewController = segue.destination as! ContainerViewController
    
        containerViewController.place = place
    }
    
    //populate the different search categories
    private func populatepuCategoriesForPlaces() {
        
        for category in categoryPlaces {
            
            let place = Place()
            place.title = category
            
            self.places.append(place)
        }
        
    }
    
    
    
}
