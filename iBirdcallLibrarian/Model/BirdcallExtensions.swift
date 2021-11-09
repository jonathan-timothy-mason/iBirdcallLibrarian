//
//  BirdcallExtensions.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 31/10/2021.
//

import Foundation

extension Birdcall {
    /// Create unique filename for birdcall recording.
    static func createAudioFilename() -> String {
        return UUID().uuidString + ".wav"
    }
    
    /// Get URL of birdcall recording.
    var audioFilenameURL: URL {
        guard let audioFilename = self.audioFilename else {
            fatalError("Audio filename is empty whilst attempting to get URL.")
        }
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let pathArray = [dirPath, audioFilename]
        
        if let filePath = URL(string: pathArray.joined(separator: "/")) {
            return filePath
        }
        else {
            fatalError("Could not create URL for audio filename \(audioFilename).")
        }
    }
    
    /// Get default birdcall title based upon whether date it is morning, afternoon, evening or night.
    /// - Parameter date: Date at which birdcall was recorded.
    /// - Returns: Default title.
    static func getDefaultTitle(_ date: Date) -> String {
        // From "Get hours, minutes and seconds from Date with Swift" by Darren:
        // https://programmingwithswift.com/get-hours-minutes-seconds-date-swift/
        let hourOfDay = Calendar.current.component(.hour, from: date)

        if(hourOfDay >= 21 || hourOfDay < 4) {
            return "Night Birdcall"
        }
        else if(hourOfDay >= 18) {
            return "Evening Birdcall"
        }
        else if(hourOfDay >= 12) {
            return "Afternoon Birdcall"
        }
        else /* From 4am */ {
            return "Morning Birdcall"
        }
    }
    
    /// Get caption for birdcall, for use in map or table view.
    /// - Note: Use species, otherwise title, otherwise question mark.
    func getCaption() -> String {
        if let species = self.species, !species.isEmpty {
            return species
        }
        else if let title = self.title, !title.isEmpty {
            return title
        }
        else {
            return "?"
        }
    }
}
