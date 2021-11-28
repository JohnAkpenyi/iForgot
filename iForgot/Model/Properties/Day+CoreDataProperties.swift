//
//  Day+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 23/11/2021.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var listOfActivities: [String]?
    @NSManaged public var date: Date?
    @NSManaged public var origon: Focus?

}

extension Day : Identifiable {

}
