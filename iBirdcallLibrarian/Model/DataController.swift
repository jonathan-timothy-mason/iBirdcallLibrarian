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
    func loadDataStore() {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
    /// Save data store.
    func saveDataStore() {
        do {
            try viewContext.save()
        }
        catch {
            print("The following error occurred whilst attempting to save birdcall to data store: \(error.localizedDescription)")
        }
    }
    
    /// Load birdcalls from data store.
    func loadBirdcalls() -> [Birdcall] {
        
        let fetchRequest = Birdcall.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try viewContext.fetch(fetchRequest)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Delete birdcall from data store and its audio file from file system.
    func deleteBirdcall(birdcall: Birdcall ) {
        do {
            try FileManager.default.removeItem(atPath: birdcall.audioFilenameURL.path)
            viewContext.delete(birdcall)
            saveDataStore()
        }
        catch {
            print("The following error occurred whilst attempting to delete birdcall \(error.localizedDescription)")
        }
    }
}
