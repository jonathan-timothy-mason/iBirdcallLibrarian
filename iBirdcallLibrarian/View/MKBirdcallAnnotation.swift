//
//  MKBirdcallAnnotation.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import MapKit

/// Map annotation including Birdcall.
/// Inspired by  Gamaliel Tellez Ortiz's question "How to create a custom class that conforms to MKAnnotation
/// protocol.":
/// https://stackoverflow.com/questions/32323080/how-to-create-a-custom-class-that-conforms-to-mkannotation-protocol
class MKBirdcallAnnotation: MKPointAnnotation {
    /// Birdcall associated with annotation.
    var birdcall: Birdcall
    
    /// Initialiser.
    /// - Parameter birdcall: Birdcall associated with annotation.
    init(_ birdcall: Birdcall) {
        self.birdcall = birdcall
    }
}
