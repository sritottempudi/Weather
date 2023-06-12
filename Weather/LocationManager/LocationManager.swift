//
//  LocationManager.swift
//  Weather
//
//  Created by Srinivasa Tottempudi on 6/11/23.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    // Notifies the listner if there is any location update in the background
    func didChangeAuthorization(status: CLAuthorizationStatus, location: CLLocation?)
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let shared = LocationManager()
    private var locationManager: CLLocationManager = CLLocationManager()
    var requestLocationAuthorizationCallback: ((CLAuthorizationStatus, CLLocation?) -> Void)?
    weak var delegate: LocationManagerDelegate?
    
    /// Checks for location Access and requests if user permission is not provided
    public func requestLocationAuthorization() {
        self.locationManager.delegate = self

        // Only ask authorization if it was never asked before
        guard locationManager.authorizationStatus == .notDetermined else { return }
        
        if #available(iOS 13.4, *) {
            self.requestLocationAuthorizationCallback = { status, _ in
                if status == .authorizedWhenInUse {
                    self.locationManager.requestAlwaysAuthorization()
                }
            }
            self.locationManager.requestWhenInUseAuthorization()
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status, manager.location)
        guard manager.location != nil else {
            return
        }
        delegate?.didChangeAuthorization(status: status, location: locationManager.location)
    }
    
    func currentLocation() -> CLLocation? {
        return locationManager.location
    }
}
