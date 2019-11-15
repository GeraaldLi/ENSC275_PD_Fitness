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
    
    @IBAction func testButton(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "coffee"
        searchRequest.region = mapView.region
    }
    
    
    @IBAction func selectResources(_ sender: UISegmentedControl) {
        
        
        /*
         https://www.youtube.com/watch?v=Wdy1H7P_J4A&list=PL23Revp-82LJw1dxVR9-6byAQXGPPeTum&index=3
         */
        if sender.selectedSegmentIndex == 0{
            
             var region = MKCoordinateRegion()
             region.center = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
             
            let request = MKLocalSearch.Request()
             request.naturalLanguageQuery = "Coffee Shops"
             request.region = region
             
             let search = MKLocalSearch(request: request)
             search.start { (response, error) in
                 
                print(response?.mapItems as Any)
                
                 guard let response = response else {
                     return
                 }
                 
                 for item in response.mapItems {
                     
                     let annotation = MKPointAnnotation()
                     annotation.coordinate = item.placemark.coordinate
                     annotation.title = item.name
                     
                     DispatchQueue.main.async {
                         self.mapView.addAnnotation(annotation)
                     }
                 }
             }
            // Set the region to an associated map view's region
            
            
        }else if sender.selectedSegmentIndex == 1{
            
            
        }else{
          
        }
    }
    
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
               mapView.setUserTrackingMode(.follow, animated: true)
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    

}
