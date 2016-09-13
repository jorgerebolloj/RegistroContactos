//
//  RegistroContactos+CoreDataProperties.swift
//  RegistroContactos
//
//  Created by Jorge Rebollo J on 12/09/16.
//  Copyright © 2016 RGStudio. All rights reserved.
//

import Foundation
import CoreData

extension RegistroContactos {
    
    @NSManaged var name: String?
    @NSManaged var telephone: String?
    @NSManaged var civilStatus: String?
    @NSManaged var sex: String?
    @NSManaged var personalInterest: String?
    
}