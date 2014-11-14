//
//  EditArtistViewController.swift
//  ArtistDatabase
//
//  Created by Lukas Streiter on 13/11/14.
//  Copyright (c) 2014 Lukas Streiter. All rights reserved.
//

import UIKit
import CoreData

class EditArtistViewController: UIViewController {
    
    var artist: Artist?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    @IBOutlet weak var artistName: UITextField!
    @IBOutlet weak var artistLabel: UITextField!
    
    override func viewDidLoad() {
        if let artist = self.artist {
            self.artistName.text = artist.name
            self.artistLabel.text = artist.label
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewController()
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if self.artistName.text.isEmpty || self.artistLabel.text.isEmpty {
            return
        }
        
        let entityDescription = NSEntityDescription.entityForName("Artist", inManagedObjectContext: self.managedObjectContext)
        
        // Either insert or update the artist.
        if self.artist == nil {
            // Create the artist object.
            self.artist = Artist(entity: entityDescription!, insertIntoManagedObjectContext: self.managedObjectContext)
        }
        
        // Fill the artist object.
        self.artist!.name = self.artistName.text
        self.artist!.label = self.artistLabel.text
        
        // Insert/Update the artist.
        self.managedObjectContext.save(nil)
        
        // Pop the ViewController from stack.
        dismissViewController()
    }
    
    func dismissViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}