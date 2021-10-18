//
//  MapState.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 13/10/2021.
//

import MapKit

/// Manages saving of map state to UserDefaults.
/// Based on the answer to question "Save Zoom level of Map" by Tran V:
/// https://knowledge.udacity.com/questions/138741
class MapState {
    
    /// Keys for UserDefaults.
    struct Keys {
        static let hasSavedBefore: String = "hasSavedBefore"
        static let latitude: String = "latitude"
        static let longitude: String = "longitude"
        static let latitudeDelta: String = "latitudeDelta"
        static let longitudeDelta: String = "longitudeDelta"
    }
    
    /// Restore map position and zoom level.
    /// - Returns: New map region containing previous position and zoom level.
    static func loadRegion() -> MKCoordinateRegion? {
        guard UserDefaults.standard.bool(forKey: Keys.hasSavedBefore) else {
            return nil
        }
        
        var mapRegion = MKCoordinateRegion()
        mapRegion.center.latitude = UserDefaults.standard.double(forKey: Keys.latitude)
        mapRegion.center.longitude = UserDefaults.standard.double(forKey: Keys.longitude)
        mapRegion.span.latitudeDelta = UserDefaults.standard.double(forKey: Keys.latitudeDelta)
        mapRegion.span.longitudeDelta = UserDefaults.standard.double(forKey: Keys.longitudeDelta)
        
        return mapRegion
    }
    
    
    /// Save map position and zoom level.
    /// - Parameter mapRegion: Current map region containing position and zoom level.
    static func saveRegion(mapRegion: MKCoordinateRegion?) {
        if let mapRegion = mapRegion {
            UserDefaults.standard.set(true, forKey: Keys.hasSavedBefore)
            UserDefaults.standard.set(mapRegion.center.latitude, forKey: Keys.latitude)
            UserDefaults.standard.set(mapRegion.center.longitude, forKey: Keys.longitude)
            UserDefaults.standard.set(mapRegion.span.latitudeDelta, forKey: Keys.latitudeDelta)
            UserDefaults.standard.set(mapRegion.span.longitudeDelta, forKey: Keys.longitudeDelta)
        }
    }
}
