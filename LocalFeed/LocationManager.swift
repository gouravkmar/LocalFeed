//
//  LocationManager.swift
//  LocalFeed
//
//  Created by New User on 16/07/22.
//

import Foundation
import CoreLocation

class LocationManager:NSObject, CLLocationManagerDelegate {
    
    static var currentLocation = CLLocation(latitude: 0, longitude: 0)
    static var locationAvailable  :  Bool = false
    let locationManager = CLLocationManager()
    override init(){
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            if let loc = locationManager.location {
                LocationManager.currentLocation = loc
                LocationManager.locationAvailable = true
                NotificationCenter.default.post(name: Notification.Name("localFeed.locationUpdated"), object: nil)
            }
            
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty {
            
            LocationManager.currentLocation = locations.first!
            LocationManager.locationAvailable = true
            
        }
    }
    
    
}
