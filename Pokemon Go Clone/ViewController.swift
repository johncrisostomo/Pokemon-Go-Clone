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
            
            setUp()
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            setUp()
            
        }
    }
    
    func setUp() {
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation!, animated: true)
        
        if view.annotation! is MKUserLocation {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if let coord = self.manager.location?.coordinate {
                
                let pokemon = (view.annotation as! PokeAnnotation).pokemon
                
                if MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    print("can catch pokemon")
                    
                    pokemon.caught = true
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertVC = UIAlertController(title: "Congrats", message: "You have caught a \(pokemon.name!)!", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                        
                        })
                    
                    let pokedexAction = UIAlertAction(title: "Pokedex", style: .default, handler: { (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                        
                    alertVC.addAction(pokedexAction)
                    alertVC.addAction(okAction)
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    let alertVC = UIAlertController(title: "Uh-oh", message: "You are too far away to catch the \(pokemon.name!)", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                    })
                    
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
            }
        })
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

