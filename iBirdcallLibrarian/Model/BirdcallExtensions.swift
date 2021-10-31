//
//  BirdcallExtensions.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 31/10/2021.
//

import Foundation

extension Birdcall {
    /// Get default birdcall title based upon whether date it is morning, afternoon, evening or night.
    /// - Parameter date: date at which birdcall was recorded.
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
}
