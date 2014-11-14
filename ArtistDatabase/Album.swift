//
//  Album.swift
//  ArtistDatabase
//
//  Created by Lukas Streiter on 14/11/14.
//  Copyright (c) 2014 Lukas Streiter. All rights reserved.
//

import Foundation
import CoreData

class Album: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var year: String
    @NSManaged var format: String
    @NSManaged var artist: Artist

}
