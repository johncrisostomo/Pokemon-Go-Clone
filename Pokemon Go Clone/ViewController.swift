//
//  ViewController.swift
//  Pokemon Go Clone
//
//  Created by John Crisostomo on 14/04/2017.
//  Copyright © 2017 John Crisostomo. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var updateCount = 0
    
    var pokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        pokemons = getAllPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.delegate = self
            
            mapView.showsUserLocation = true
            
            manager.startUpdatingLocation()
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (timer) in
                
                if let coords = self.manager.location?.coordinate {
                    let pokemon = self.pokemons[Int(arc4random_uniform(UInt32(self.pokemons.count)))]
                    
                    let annotation = PokeAnnotation(coord: coords, pokemon: pokemon)
                    
                    let randomLon = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 50000.0
                    
                    annotation.coordinate.latitude += randomLat
                    annotation.coordinate.longitude += randomLon
                    
                    self.mapView.addAnnotation(annotation)
                }
                
            })
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let userAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            userAnnotation.image = UIImage(named: "player")
            
            userAnnotation.frame.size.height = 50
            userAnnotation.frame.size.width = 50
            
            return userAnnotation
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        let pokemon = (annotation as! PokeAnnotation).pokemon
        
        annotationView.image = UIImage(named: pokemon.imageName!)
        
        var frame = annotationView.frame
        
        frame.size.height = 50
        frame.size.width = 50
        
        annotationView.frame = frame
        
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 3 {
            let region = MKCoordinateRegionMakeWithDistance(manager.location!.coordinate, 200, 200)
            
            mapView.setRegion(region, animated: false)
            
            updateCount += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @IBAction func centerTapped(_ sender: Any) {
        if let coord = manager.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func pokeballTapped(_ sender: Any) {
        
    }
}

