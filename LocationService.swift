//
//  LocationService.swift
//  Should I Ride?
//
//  Created by Andy Seavers on 12/17/15.
//  Copyright © 2015 Andy Seavers. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import MapKit


class LocationService {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        print(center)
        
        //self.locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
}