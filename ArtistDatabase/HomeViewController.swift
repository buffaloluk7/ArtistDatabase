//
//  HomeViewController.swift
//  ArtistDatabase
//
//  Created by Lukas Streiter on 13/11/14.
//  Copyright (c) 2014 Lukas Streiter. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.fetchedResultsController = getFetchedResultsController()
        self.fetchedResultsController.delegate = self
        self.fetchedResultsController.performFetch(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "showArtistSegue":
                // Store artist object in ViewController.
                let viewController = segue.destinationViewController as ArtistViewController
                viewController.artist = self.getSelectedArtist(sender as UITableViewCell)
            
            case "editArtistSegue":
                // Store artist object in ViewController.
                let viewController = segue.destinationViewController as EditArtistViewController
                viewController.artist = self.getSelectedArtist(sender as UITableViewCell)
            
            default:
                break
        }
    }

    // MARK: - Table view data source.
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let managedObject: NSManagedObject = fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
            managedObjectContext.deleteObject(managedObject)
            managedObjectContext.save(nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the artist for the given index path.
        let artist = self.getSelectedArtist(indexPath)
        
        // Fill the cell with artist details.
        let cell = tableView.dequeueReusableCellWithIdentifier("artistCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = artist.name
        cell.detailTextLabel?.text = artist.label
        
        return cell
    }
    
    // MARK: - Internal and private methods.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    private func getFetchedResultsController() -> NSFetchedResultsController {
        return NSFetchedResultsController(fetchRequest: self.fetchArtistsRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchArtistsRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Artist")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    private func getSelectedArtist(cell: UITableViewCell) -> Artist {
        let indexPath = self.tableView.indexPathForCell(cell)
        
        return self.getSelectedArtist(indexPath!)
    }
    
    private func getSelectedArtist(indexPath: NSIndexPath) -> Artist {
        return self.fetchedResultsController.objectAtIndexPath(indexPath) as Artist
    }
    
}

