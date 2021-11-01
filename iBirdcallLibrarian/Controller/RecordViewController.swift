//
//  RecordViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import UIKit
import CoreLocation
import AVFoundation

/// Records a new birdcall.
class RecordViewController: UIViewController, CLLocationManagerDelegate {
    var birdcall: Birdcall!
    let locationManager = CLLocationManager()
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create new birdcall.
        birdcall = Birdcall(context: DataController.shared.viewContext)
        birdcall.date = Date()
        birdcall.title = Birdcall.getDefaultTitle(birdcall.date!)
        birdcall.audioFilename = Birdcall.createAudioFilename()
        
        // Attempt to begin process of receiving current location.
        setupLocationManager()
        
        // Start recording.
        startRecording()
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
        birdcall.latitude = location.coordinate.latitude + Double.random(in: -10...10)
        birdcall.longitude = location.coordinate.longitude + Double.random(in: -10...10)
    }
    
    /// Record audio.
    /// From Lesson 4 Delegation and Recording, Intro to iOS App Development with Swift, Pitch Perfect.
    func startRecording() {
        do {
            let url = birdcall.audioFilenameURL
            
            // Get audio session for recording.
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

            // Setup audio recorder.
            try audioRecorder = AVAudioRecorder(url: url, settings: [:])
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
            // Start recording.
            audioRecorder.record()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
       
    /// Handle press of stop button to end recording and initiate closing of screen, saving birdcall.
    @IBAction func stopButtonPressed() {
        navigationController!.popViewController(animated: true)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        // Save birdcall when closing screen.
        // From answer to "Execute action when back bar button of UINavigationController
        // is pressed" by Iya:
        // https://stackoverflow.com/questions/27713747/execute-action-when-back-bar-button-of-uinavigationcontroller-is-pressed
        if(parent == nil) {
            stopRecording()
        }
    }
    
    /// Stop recording and save birdcall to data store.
    /// - Note: Unfortunately, only URL of audio file is saved, as Ron Diel's annswer to "How do I save and
    /// fetch audio data to/from CoreData with Objective-C?", which allows conversion of file to data, for saving
    /// to Core Data,  could not be made to work:
    /// https://stackoverflow.com/questions/41125794/how-do-i-save-and-fetch-audio-data-to-from-coredata-with-objective-c
    func stopRecording() {
        // Stop recording.
        audioRecorder.stop()
        
        // Finish with audio session.
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        // Save to data store.
        DataController.shared.save()
    }
}
