//
//  Ridedestination.swift
//  UberShare
//
//  Created by wxt on 4/28/19.
//  Copyright © 2019 BChacks. All rights reserved.
//

import MapKit

class Ridedestination: NSObject, MKAnnotation {
    let locationname: String?
    let coordinate: CLLocationCoordinate2D
    
    init(locationname: String, coordinate: CLLocationCoordinate2D){
        self.locationname = locationname
        self.coordinate = coordinate
        
        super.init()
    }
    var title: String? {
        return "Destination"
    }
    var subtitle: String?{
        return locationname
    }
}
