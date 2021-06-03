//
//  Story+CoreDataProperties.swift
//  RosterBusterDashboard
//
//  Created by Mayur Susare on 29/05/21.
//
//

import Foundation
import CoreData


extension Story {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Story> {
        return NSFetchRequest<Story>(entityName: "Story")
    }

    @NSManaged public var date: String?
    @NSManaged public var departure: String?
    @NSManaged public var destination: String?
    @NSManaged public var dutyCode: String?
    @NSManaged public var dutyID: String?
    @NSManaged public var timeArrive: String?
    @NSManaged public var timeDepart: String?

}

extension Story : Identifiable {

}
