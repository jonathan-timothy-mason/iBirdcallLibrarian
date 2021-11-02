//
//  DetailsViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import UIKit
import AVFoundation

/// Displays details of birdcall.
/// - Note: Colour of placholder text of UITextFields set in Interface Builder according to answer
/// to "Changing Placeholder Text Color with Swift" by crubio:
/// https://stackoverflow.com/questions/26076054/changing-placeholder-text-color-with-swift
class DetailsViewController: UIViewController {
    var birdcall: Birdcall!
    var audioPlayer: AVAudioPlayer!
    @IBOutlet weak var titleOfBirdcall: UITextField!
    @IBOutlet weak var species: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var latAndLong: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show details of birdcall.
        titleOfBirdcall.text = birdcall.title
        species.text = birdcall.species
        notes.text = birdcall.notes
        dateAndTime.text = birdcall.date?.formatted()
        latAndLong.text = "Lat \(String(format: "%.2f", birdcall.latitude)), Long \(String(format: "%.2f", birdcall.longitude))" // From "Formatting numbers in Swift" by John Sundell: https://swiftbysundell.com/articles/formatting-numbers-in-swift/
    }
    
    /// Handle press of button to play birdcall.
    @IBAction func playBirdcall() {
        do {
            let url = birdcall.audioFilenameURL
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save changes to birdcall.
        birdcall.title = titleOfBirdcall.text
        birdcall.species = species.text
        birdcall.notes = notes.text
        DataController.shared.save()
    }
}
