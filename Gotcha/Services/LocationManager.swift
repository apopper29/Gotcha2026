//
//  LocationManager.swift
//  Gotcha
//
//  Created on 11/1/26.
//


import Foundation
import CoreLocation
import Combine

@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus

    @Published var errorMessage: String?

    override init() {
        authorizationStatus = manager.authorizationStatus

        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.pausesLocationUpdatesAutomatically = true

        // Allow location updates while the app is in the background.
        manager.allowsBackgroundLocationUpdates = true
    }

    // MARK: - Permissions

    func requestPermission() {
        manager.requestAlwaysAuthorization()
    }

    // MARK: - Tracking

    func startTracking() {
        guard manager.authorizationStatus == .authorizedAlways ||
              manager.authorizationStatus == .authorizedWhenInUse else {
            requestPermission()
            return
        }

        manager.startUpdatingLocation()
    }

    func stopTracking() {
        manager.stopUpdatingLocation()
    }

    // MARK: - Authorization Changes

    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus = manager.authorizationStatus

        if manager.authorizationStatus == .authorizedAlways ||
           manager.authorizationStatus == .authorizedWhenInUse {

            manager.startUpdatingLocation()
        }
    }

    // MARK: - Location Updates

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let newLocation = locations.last else {
            return
        }

        // Reject invalid or inaccurate GPS readings.
        guard newLocation.horizontalAccuracy >= 0,
              newLocation.horizontalAccuracy <= 50 else {
            return
        }

        location = newLocation
        errorMessage = nil

        print("New location:")
        print("Latitude: \(newLocation.coordinate.latitude)")
        print("Longitude: \(newLocation.coordinate.longitude)")
        print("Accuracy: \(newLocation.horizontalAccuracy)m")
    }

    // MARK: - Errors

    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        errorMessage = error.localizedDescription
        print("Location error:", error.localizedDescription)
    }
}
