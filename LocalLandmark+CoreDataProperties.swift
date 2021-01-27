//
//  LocalLandmark+CoreDataProperties.swift
//  travelapp (iOS)
//
//  Created by Thomas Gosse on 25/01/2021.
//
//

import Foundation
import CoreData


extension LocalLandmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalLandmark> {
        return NSFetchRequest<LocalLandmark>(entityName: "LocalLandmark")
    }

    @NSManaged public var countryCode: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var personalNote: String
    @NSManaged public var pointOfInterestCategory: String?
    @NSManaged public var subtitle: String
    @NSManaged public var title: String
    @NSManaged public var visited: Bool
    @NSManaged public var url: URL?

}

extension LocalLandmark : Identifiable {

}
