//
//  DataController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import Foundation
import CoreData

/// Helper for using data store.
/// Based on "What Is a Singleton and How To Create One In Swift" by Bart Jacobs:
/// https://cocoacasts.com/what-is-a-singleton-and-how-to-create-one-in-swift/
class DataController {
    static let shared = DataController()
    let persistentContainer = NSPersistentContainer(name: "Birdcalls")
    
    /// Context for accessing data store for main thread.
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
           
    /// Load data store.
    func load() {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
    /// Save data store, logging any error.
    func save() {
        do {
            try DataController.shared.viewContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
