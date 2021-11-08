//
//  ControllerHelpers.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 08/11/2021.
//

import UIKit

/// Various helpers related to view controllers.
class ControllerHelpers {
    /// Display error message using Alert Controller.
    /// - Parameters:
    ///   - parent: Parent View Controller.
    ///   - caption: Caption of alert.
    ///   - introMessage: Introductory message to display.
    ///   - error: Error to display.
    static func showMessage(parent: UIViewController, caption: String, introMessage: String, error: Error?) {
        var message = introMessage
        if let error = error {
            message += ": " + error.localizedDescription
        }
        else {
            message += "."
        }
        
        showMessage(parent: parent, caption: caption, message: message)
    }
    
    /// Display message using Alert Controller.
    /// - Parameters:
    ///   - parent: Parent View Controller.
    ///   - caption: Caption of alert.
    ///   - message: Message to display.
    static func showMessage(parent: UIViewController, caption: String, message: String) {
        let alert = UIAlertController(title: caption, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        parent.present(alert, animated: true)
    }
}
