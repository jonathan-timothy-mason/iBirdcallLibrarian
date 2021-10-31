//
//  RecordViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import UIKit
import CoreLocation

/// Records a new birdcall.
class RecordViewController: UIViewController, CLLocationManagerDelegate {
    var birdcall: Birdcall!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new birdcall.
        birdcall = Birdcall(context: DataController.shared.viewContext)
        birdcall.date = Date()
        birdcall.title = "New birdcall"
        
        // Attempt to begin process of receiving current location.
        setupLocationManager()
    }
    
    /// Attempt to begin process of receiving current location.
    /// From "How To Get Current Location in Swift" by Eddy Chung:
    /// https://www.zerotoappstore.com/how-to-get-current-location-in-swift.html
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError: Error) {
        print(didFailWithError.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }
        let currentDate = Date()
        guard currentDate.timeIntervalSince(location.timestamp) <= (60 * 60) else {
            print("Time of last location update at \(location.timestamp.description) is too long ago.")
            return
        }
        
        // As soon as location updated, no more updates needed.
        manager.stopUpdatingLocation()
        
        // Record current location in birdcall.
        birdcall.latitude = location.coordinate.latitude
        birdcall.longitude = location.coordinate.longitude
    }
    
    /// Save to data store.
    func save() {
        DataController.shared.save()
    }
    
    /// Handle press of stop button to end recording and save birdcall.
    @IBAction func stopButtonPressed() {
        
    }
}
