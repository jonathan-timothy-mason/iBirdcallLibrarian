//
//  SettingsViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 15/11/2021.
//

import Foundation
import UIKit

/// Manages user settings.
class SettingsViewController: UIViewController {
    @IBOutlet weak var autoPlay: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialise settings.
        autoPlay.isOn = Settings.getAutoPlay()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save settings.
        Settings.setAutoPlay(autoPlay.isOn)
    }
}
