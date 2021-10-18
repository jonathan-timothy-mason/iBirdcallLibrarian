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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // From answer to "iOS : Swift - How to add pinpoint to map on touch and get
        // detailed address of that location?" by Peter Pohlmann:
        //https://stackoverflow.com/questions/34431459/ios-swift-how-to-add-pinpoint-to-map-on-touch-and-get-detailed-address-of-th
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Restore map position and zoom level.
        if let region = MapState.loadRegion() {
            mapView.region = region
        }
        
        // Load birdcalls from data store and populate map.
        loadBirdcalls()
    }
    
    /// Load birdcalls from data store and populate map.
    func loadBirdcalls() {
        
        let fetchRequest = Birdcall.fetchRequest()
        do {
            birdcalls = try DataController.shared.viewContext.fetch(fetchRequest)
        }
        catch {
            fatalError(error.localizedDescription)
        }
        
        generateAnnotations();
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
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Display details of selected birdcall.
        if let annotation = view.annotation as? MKBirdcallAnnotation {
            let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            detailsViewController.birdcall = annotation.birdcall
            navigationController!.pushViewController(detailsViewController, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Save map position and zoom level.
        MapState.saveRegion(mapRegion: mapView.region)
    }
    
    /// Handle long press of map to add new travel location.
    /// From answer to "iOS : Swift - How to add pinpoint to map on touch and get detailed
    /// address of that location?" by Peter Pohlmann:
    /// https://stackoverflow.com/questions/34431459/ios-swift-how-to-add-pinpoint-to-map-on-touch-and-get-detailed-address-of-th
    /// - Parameter sender: Long press gesture recogniser.
    @objc func longTap(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            // Get latitide and longitude of pressed point of map.
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
          
            
            sender.state = .ended // Workaround to allow new long press straightaway.
        }
    }
    
    /// Handle press of record button to show RecordViewController.
    @IBAction func recordButtonPressed() {
        let recordViewController = self.storyboard!.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
        navigationController!.pushViewController(recordViewController, animated: true)
    }
}

