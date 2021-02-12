//
//  User+CoreDataProperties.swift
//  Escale (iOS)
//
//  Created by Thomas Gosse on 12/02/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?

}

extension User : Identifiable {

}
