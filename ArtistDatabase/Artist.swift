//
//  Artist.swift
//  ArtistDatabase
//
//  Created by Lukas Streiter on 14/11/14.
//  Copyright (c) 2014 Lukas Streiter. All rights reserved.
//

import Foundation
import CoreData

class Artist: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var label: String
    @NSManaged var albums: NSSet

}
