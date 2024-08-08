//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by Low Jung Xuan on 08/08/2024.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?

}
