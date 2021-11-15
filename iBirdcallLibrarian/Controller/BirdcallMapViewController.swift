//
//  ViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import UIKit
import MapKit

/// Displays map of birdcalls.
/// Based on PinSample by Jason, Udacity.
class BirdcallMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var recordButton: UIButton!
    
    var birdcalls: [Birdcall] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restore map position and zoom level.
        if let region = MapState.loadRegion() {
            mapView.region = region
        }
        
        // Load birdcalls from data store.
        birdcalls = DataController.shared.loadBirdcalls()
        
        // Generate map annotations for birdcalls.
        generateAnnotations()
    }
    
    /// Generate map annotations for birdcalls.
    func generateAnnotations() {
        // Remove previous annotations, if any.
        mapView.removeAnnotations(self.mapView.annotations)
               
        // Create annotation for each birdcall.
        var annotations = [MKBirdcallAnnotation]()
        for birdcall in birdcalls {
            let latitude = CLLocationDegrees(birdcall.latitude)
            let longitude = CLLocationDegrees(birdcall.longitude)
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKBirdcallAnnotation(birdcall)
            annotation.title = birdcall.getCaption()
            annotation.subtitle = birdcall.date!.formatted()           
            annotation.coordinate = coordinates
            annotations.append(annotation)
        }
        
        // Add array of annotations to map.
        mapView.addAnnotations(annotations)
    }
    
    static let pinReuseId = "pin"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Provide pin view for each birdcall, as required.
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: BirdcallMapViewController.pinReuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: BirdcallMapViewController.pinReuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
        
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Handle press of callout to display details of selected birdcall.
        if control == view.rightCalloutAccessoryView {
            if let annotation = view.annotation as? MKBirdcallAnnotation {
                let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                detailsViewController.birdcall = annotation.birdcall
                detailsViewController.hidesBottomBarWhenPushed = true // Prevent tabs showing in new screen.
                navigationController!.pushViewController(detailsViewController, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Save map position and zoom level.
        MapState.saveRegion(mapRegion: mapView.region)
    }
    
    /// Handle press of record button to show RecordViewController.
    @IBAction func recordButtonPressed() {
        let recordViewController = self.storyboard!.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
        recordViewController.hidesBottomBarWhenPushed = true // Prevent tabs showing in new screen.
        navigationController!.pushViewController(recordViewController, animated: true)
    }
    
    /// Handle press of settings button to show SettingsViewController.
    @IBAction func settingsButtonPressed() {
        let settingsViewController = self.storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsViewController.hidesBottomBarWhenPushed = true // Prevent tabs showing in new screen.
        navigationController!.pushViewController(settingsViewController, animated: true)
    }

}

