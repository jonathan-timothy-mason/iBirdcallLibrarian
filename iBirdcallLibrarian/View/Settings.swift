//
//  Settings.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 15/11/2021.
//

import Foundation

/// Manages persistence of settings to UserDefaults.
class Settings {
    
    /// Keys for UserDefaults.
    struct Keys {
        static let autoPlay: String = "autoPlay"
    }
    
    /// Get auto-play setting.
    /// - Returns: Auto-play setting.
    static func getAutoPlay() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.autoPlay)
    }
    
    
    /// Set auto-play setting.
    /// - Parameter autoPlay: Auto-play setting.
    static func setAutoPlay(_ autoPlay: Bool) {
        UserDefaults.standard.set(autoPlay, forKey: Keys.autoPlay)
    }
}
