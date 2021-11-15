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
    @IBOutlet weak var onAir: UILabel!
    @IBOutlet weak var titleOfBirdcall: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide back button, only allowing stop button to close screen, saving
        // recording and indicating success.
        // From answer to "Nav Back button not hidden" by Francisco G:
        // https://knowledge.udacity.com/questions/286425
        navigationItem.setHidesBackButton(true, animated: false)
        
        // Create new birdcall.
        birdcall = Birdcall(context: DataController.shared.viewContext)
        birdcall.date = Date()
        birdcall.title = Birdcall.getDefaultTitle(birdcall.date!)
        birdcall.audioFilename = Birdcall.createAudioFilename()
        
        // Attempt to begin process of receiving current location.
        setupLocationManager()
        
        // Start recording.
        startRecording()
        
        // Flash ON-AIR label.
        flashOnAir()
        
        // Show details of birdcall.
        titleOfBirdcall.text = birdcall.title
        dateAndTime.text = birdcall.date?.formatted()
    }
    
    /// Flash ON-AIR label.
    /// - Note: From answer to "Blocks on Swift (animateWithDuration:animations:completion:)" by Nicholas H:
    /// https://stackoverflow.com/questions/24071334/blocks-on-swift-animatewithdurationanimationscompletion#24071442
    func flashOnAir() {
        if audioRecorder.isRecording {
            UIView.animate(withDuration: 1) {
                self.onAir.alpha = 0 // Fade out
            } completion: { _ in
                UIView.animate(withDuration: 1) {
                    self.onAir.alpha = 1 // Fade in
                } completion: { _ in
                    self.flashOnAir() // Repeat
                }
            }
        }
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
       
    /// Handle press of stop button to end recording and save birdcall, closing screen after indicating OFF-AIR.
    @IBAction func stopButtonPressed() {
        stopRecording()

        // From answer to "Blocks on Swift (animateWithDuration:animations:completion:)" by Nicholas H:
        // https://stackoverflow.com/questions/24071334/blocks-on-swift-animatewithdurationanimationscompletion#24071442
        onAir.text = "OFF-AIR"
        onAir.alpha = 0
        UIView.animate(withDuration: 0.25) {
            // Fade in OFF-AIR.
            self.onAir.alpha = 1
        } completion: { _ in
            // Allow user to see OFF-AIR for a period before closing screen.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                // From answer to "How to create a delay in Swift?" by Naresh:
                // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
                self.navigationController!.popViewController(animated: true)
            }
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
        DataController.shared.saveDataStore()
    }
}
