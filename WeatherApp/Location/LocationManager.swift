//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Денис Винокуров on 19.07.2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyReduced
        manager.delegate = self
        manager.startUpdatingLocation()
    }

    func getCurrentLocation() -> (latitude: Double, longitude: Double) {
        manager.startUpdatingLocation()
        if let longitude = manager.location?.coordinate.longitude,
           let latitude = manager.location?.coordinate.latitude {
            manager.stopUpdatingLocation()
            return (latitude: latitude, longitude: longitude)
        } else {
            manager.stopUpdatingLocation()
            return (0, 0)
        }
    }

    func getStringAddress(completion: @escaping (String) -> Void) {
        guard let location = manager.location else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemark, error in
            guard let place = placemark?.first, error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }

            completion(place.locality ?? "Empty locality")
        }
    }

    func getLocationAutorizationStatus() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .denied, .notDetermined, .restricted:
            NotificationCenter.default.post(name: .locationNotification,
                                            object: nil,
                                            userInfo: ["authorizationStatus": manager.authorizationStatus])
            return
        default:
            manager.startUpdatingLocation()
            NotificationCenter.default.post(name: .locationNotification,
                                            object: nil,
                                            userInfo: ["authorizationStatus": manager.authorizationStatus])
        }
    }

}
