//
//  BirdcallTableViewController.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 09/11/2021.
//

import UIKit
import MapKit

/// Displays table of birdcalls.
class BirdcallTableViewController: UITableViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    
    var birdcalls: [Birdcall] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load birdcalls from data store and populate table.
        loadBirdcalls()
    }
    
    /// Load birdcalls from data store and populate table.
    func loadBirdcalls() {
        
        let fetchRequest = Birdcall.fetchRequest()
        do {
            birdcalls = try DataController.shared.viewContext.fetch(fetchRequest)
            tableView.reloadData()
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birdcalls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BirdcallCell") as! BirdcallCell
        let birdcall = birdcalls[(indexPath as NSIndexPath).row]
        
        // Set text and image of cell.
        cell.caption.text = "\(birdcall.getCaption())"
        cell.dateAndTime.text = "\(birdcall.date!.formatted())"
        if let photo = birdcall.photo {
            cell.photo.image = UIImage(data: photo)
            cell.photo.contentMode = .scaleAspectFit
        }
        else {
            cell.photo.image = UIImage(systemName: "doc.text.image")
            cell.photo.contentMode = .center
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle press of item to display details of selected birdcall.
        let detailsViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.birdcall = birdcalls[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailsViewController, animated: true)
    }

    /// Handle press of record button to show RecordViewController.
    @IBAction func recordButtonPressed() {
        let recordViewController = self.storyboard!.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
        navigationController!.pushViewController(recordViewController, animated: true)
    }
}

