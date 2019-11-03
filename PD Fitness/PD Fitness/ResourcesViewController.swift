//
//  ResourcesViewController.swift
//  PD Fitness
//
//  Created by Reed Lu on 2019-11-02.
//  Copyright © 2019 Soroush Saheb-Pour Lighvan . All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ResourcesViewController: UIViewController {
    let regionRadius: CLLocationDistance = 1000
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    
    /*
     Source for func demoVGH:
     https://www.youtube.com/watch?v=INfCmCxLC0o
    */
    @IBAction func demoVGH(_ sender: Any) {
        //define the latitude and longitude of VGH
        let latitude:CLLocationDegrees = 49.261554
        let longitude:CLLocationDegrees = -123.123876
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate:regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "Vancouver General Hospital"
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //define the placeholder text for search bar
        searchBar.placeholder = "Search for a nearby resource"
    }
    
    

}
