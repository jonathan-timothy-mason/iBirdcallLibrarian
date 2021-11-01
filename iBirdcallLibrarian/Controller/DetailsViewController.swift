//
//  DetailsViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import UIKit
import AVFoundation

/// Displays details of birdcall.
class DetailsViewController: UIViewController {
    var birdcall: Birdcall!
    var audioPlayer: AVAudioPlayer!
    
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
}
