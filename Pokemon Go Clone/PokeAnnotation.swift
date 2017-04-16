//
//  PokeAnnotation.swift
//  Pokemon Go Clone
//
//  Created by John Crisostomo on 16/04/2017.
//  Copyright © 2017 John Crisostomo. All rights reserved.
//

import UIKit
import MapKit

class PokeAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    
    init(coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}

