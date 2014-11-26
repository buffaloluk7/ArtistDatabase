//
//  ArtistViewController.swift
//  ArtistDatabase
//
//  Created by Lukas Streiter on 13/11/14.
//  Copyright (c) 2014 Lukas Streiter. All rights reserved.
//

import UIKit
import CoreData

class ArtistViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var artist: Artist!
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    var fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
            case "addAlbumSegue":
                let viewController = segue.destinationViewController as EditAlbumViewController
                viewController.artist = self.artist
            
            case "editAlbumSegue":
                let album = self.getSelectedAlbum(sender as UITableViewCell)            
                let viewController = segue.destinationViewController as EditAlbumViewController
                viewController.album = album
            
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchedResultsController = self.getFetchedResultsController()
        self.fetchedResultsController.delegate = self
        self.fetchedResultsController.performFetch(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            let managedObject: NSManagedObject = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
            managedObjectContext.deleteObject(managedObject)
            managedObjectContext.save(nil)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get the artist for the given index path.
        let album = fetchedResultsController.objectAtIndexPath(indexPath) as Album
        
        // Fill the cell with artist details.
        let cell = tableView.dequeueReusableCellWithIdentifier("albumCell", forIndexPath: indexPath) as UITableViewCell
        (cell.viewWithTag(1) as UILabel).text = album.name
        (cell.viewWithTag(2) as UILabel).text = "(\(album.format))"
        (cell.viewWithTag(3) as UILabel).text = album.year
        
        return cell
    }
    
    // MARK: - Private and internal methods.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    private func getFetchedResultsController() -> NSFetchedResultsController {
        return NSFetchedResultsController(fetchRequest: self.fetchAlbumsRequest(), managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchAlbumsRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Album")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "artist == %@", self.artist)
        
        return fetchRequest
    }
    
    private func getSelectedAlbum(cell: UITableViewCell) -> Album {
        let indexPath = self.tableView.indexPathForCell(cell)
        
        return self.getSelectedAlbum(indexPath!)
    }
    
    private func getSelectedAlbum(indexPath: NSIndexPath) -> Album {
        return self.fetchedResultsController.objectAtIndexPath(indexPath) as Album
    }
    
}