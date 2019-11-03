//
//  MapViewController.swift
//  Team: PD Fitness
//  Programmers: Reed Lu
//

import UIKit
import MapKit
import CoreLocation


class MapViewController: UIViewController {
    let regionRadius: CLLocationDistance = 1000
    
    
    /*
     Source for func nearestResource:
     https://www.youtube.com/watch?v=INfCmCxLC0o
    */
    @IBAction func nearestResource(_ sender: Any) {
        //define the latitude and longitude of VGH
        let latitude:CLLocationDegrees = 49.261554
        let longitude:CLLocationDegrees = -123.123876
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        //define the launch options
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate:regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "Vancouver General Hospital"
        mapItem.openInMaps(launchOptions: options)
        
    }
    


    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    
    /*
        Source for hiding navigation bar:
        https://stackoverflow.com/questions/47150880/hide-navigation-bar-for-a-view-controller?rq=1
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    // Hide the Navigation Bar
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    // Show the Navigation Bar
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }

}

