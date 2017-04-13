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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            print("Ready to go!")
            mapView.showsUserLocation = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
}

