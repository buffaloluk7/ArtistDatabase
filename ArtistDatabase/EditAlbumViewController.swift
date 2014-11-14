//
//  EditAlbumViewController.swift
//  ArtistDatabase
//
//  Created by Lukas Streiter on 13/11/14.
//  Copyright (c) 2014 Lukas Streiter. All rights reserved.
//

import UIKit
import CoreData

class EditAlbumViewController: UIViewController {
    
    var artist: Artist?
    var album: Album?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var albumYear: UITextField!
    @IBOutlet weak var albumFormat: UITextField!
    
    override func viewDidLoad() {
        if let album = self.album {
            self.albumName.text = album.name
            self.albumYear.text = album.year
            self.albumFormat.text = album.format
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if self.albumName.text.isEmpty || self.albumYear.text.isEmpty || self.albumFormat.text.isEmpty {
            return
        }
        
        let entityDescription = NSEntityDescription.entityForName("Album", inManagedObjectContext: self.managedObjectContext)
        
        // Get the artist reference either from the artist itself or the album.
        let artist = self.artist != nil ? self.artist : album?.artist
        
        // Either insert or update the album.
        if self.album == nil {
            // Create the album object.
            self.album = Album(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
        }
        
        // Fill the album object.
        self.album!.name = self.albumName.text
        self.album!.year = self.albumYear.text
        self.album!.format = self.albumFormat.text
        self.album!.artist = artist!
        
        // Insert/Update the artist.
        self.managedObjectContext.save(nil)
        
        // Pop the ViewController from stack.
        dismissViewController()
    }
    
    func dismissViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}