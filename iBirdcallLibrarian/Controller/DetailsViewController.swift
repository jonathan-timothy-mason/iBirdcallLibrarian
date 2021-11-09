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
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleOfBirdcall: UITextField!
    @IBOutlet weak var species: UITextField!
    @IBOutlet weak var notes: UITextField!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var latAndLong: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tap handler for image.
        // From answer to "How to assign an action for UIImageView object in Swift" by Aseider:
        // https://stackoverflow.com/questions/27880607/how-to-assign-an-action-for-uiimageview-object-in-swift
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizer)
        
        // Show details of birdcall.
        titleOfBirdcall.text = birdcall.title
        species.text = birdcall.species
        notes.text = birdcall.notes
        dateAndTime.text = birdcall.date?.formatted()
        latAndLong.text = "Lat \(String(format: "%.2f", birdcall.latitude)), Long \(String(format: "%.2f", birdcall.longitude))" // From "Formatting numbers in Swift" by John Sundell: https://swiftbysundell.com/articles/formatting-numbers-in-swift/
        
        //  Load photo for birdcall from data store, if any, otherwise, Flickr.
        loadPhotoForBirdcall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save changes to birdcall.
        birdcall.title = titleOfBirdcall.text
        birdcall.species = species.text
        birdcall.notes = notes.text
        DataController.shared.save()
    }
    
    /// Load photo for birdcall from data store, if any, otherwise, Flickr.
    func loadPhotoForBirdcall() {
        // Abort if there is no species.
        guard birdcall.species != nil && birdcall.species!.isEmpty == false else {
            return
        }
        
        if let photo = birdcall.photo {
            image.image = UIImage(data: photo) // Image has already been downloaded, so set it.
        }
        else {
            loadPhotoForBirdcallFromFlickr();
        }
    }
    
    /// Load photos for birdcall from Flickr.
    func loadPhotoForBirdcallFromFlickr() {
        startIndicatingActivity()
        
        // Get photo URLs for species.
        FlickrClient.getPhotoURLsForText(text: birdcall.species!, completion: handleResponseToGetPhotoURLs)
    }
    
    /// Handle response to get photo URLs for species.
    /// - Parameters:
    ///   - urls: URLs for species.
    ///   - error: Error, if there was a problem.
    func handleResponseToGetPhotoURLs(urls: [String], error: Error?) {
        stopIndicatingActivity()
        
        guard error == nil else {
            ControllerHelpers.showMessage(parent: self, caption: "Flckr Error", introMessage: "There was a problem downloading photo URLs from Flickr.", error: error)
            return
        }
        
        // Download image for random URL.
        if urls.count > 0 {
            // Randomisation based on answer to question "The randomization limits
            // are still wrong" by Spiros R:
            // https://knowledge.udacity.com/questions/689534
            let randomIndex = Int.random(in: 0...urls.count - 1)
            
            if let url = URL(string: urls[randomIndex]) {
                startIndicatingActivity()
            
                FlickrClient.getPhoto(url: url) { photo, error in
                    self.stopIndicatingActivity()
                    
                    guard error == nil else {
                        ControllerHelpers.showMessage(parent: self, caption: "Flckr Error", introMessage: "There was a problem downloading photo from Flickr.", error: error)
                        return
                    }
                    
                    if let photo = photo {
                        self.image.image = photo // Set image of image view...
                        self.birdcall.photo = photo.pngData() // ...and data store.
                        DataController.shared.save()
                    }
                }
            }
        }
    }
    
    /// Indicate activity while photo URLs are being downloaded.
    /// - Note: User prevented from editing species or tapping image until download finished.
    func startIndicatingActivity() {
        activityIndicator.startAnimating()
        image.isHidden = true
        species.isEnabled = false
        image.isUserInteractionEnabled = false
    }
    
    /// Stop indicating activity.
    func stopIndicatingActivity() {
        self.activityIndicator.stopAnimating()
        image.isHidden = false
        species.isEnabled = true
        image.isUserInteractionEnabled = true
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
    
    /// Handle editing of species, attempting to download (new) photo.
    /// - Note: Handler of UITextField set in Interface Builder according to answer  to "How do
    /// I check when a UITextField changes?" by rmooney:
    /// https://stackoverflow.com/questions/28394933/how-do-i-check-when-a-uitextfield-changes
    @IBAction func speciesChanged() {
        birdcall.species = species.text
        clearPhoto()
        loadPhotoForBirdcall()
    }
        
    /// Handle tap of image to download new photo.
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        clearPhoto()
        loadPhotoForBirdcall()
    }
    
    /// Clear photo of birdcall.
    func clearPhoto() {
        image.image = UIImage(systemName: "doc.text.image")
        birdcall.photo = nil
    }
}
