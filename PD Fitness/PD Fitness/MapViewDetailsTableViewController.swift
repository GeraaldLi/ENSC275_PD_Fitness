//
//  MapViewDetailsTableViewController.swift
//  PD Fitness
//
//  Created by Reed Lu on 2019-11-12.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
import MapKit
import Contacts

class MapViewDetailsTableViewController: UITableViewController {

    @IBOutlet weak var addressTextView :UITextView!
    @IBOutlet weak var phoneTextView :UITextView!
    
    var mapItem :MKMapItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    func configure() {
        
        let addressElements = self.mapItem.placemark.addressDictionary?["FormattedAddressLines"] as! [String]
        
        self.addressTextView.text = addressElements.joined(separator: " ")
        self.phoneTextView.text = self.mapItem.phoneNumber!
    }

}
