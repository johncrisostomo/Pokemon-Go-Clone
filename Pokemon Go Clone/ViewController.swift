//
//  ViewController.swift
//  Pokemon Go Clone
//
//  Created by John Crisostomo on 14/04/2017.
//  Copyright © 2017 John Crisostomo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Ready to go!")
            mapView.showsUserLocation = true
            
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 400, 400)
            
            mapView.setRegion(region, animated: false)
            
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 400, 400)
        
            mapView.setRegion(region, animated: true)
        }
    }
}

