//
//  Focus+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 23/11/2021.
//
//

import Foundation
import CoreData


extension Focus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Focus> {
        return NSFetchRequest<Focus>(entityName: "Focus")
    }

    @NSManaged public var name: String?
    @NSManaged public var listOfDays: NSOrderedSet?
    @NSManaged public var origon: Focuses?

}

// MARK: Generated accessors for listOfDays
extension Focus {

    @objc(addListOfDaysObject:)
    @NSManaged public func addToListOfDays(_ value: Day)

    @objc(removeListOfDaysObject:)
    @NSManaged public func removeFromListOfDays(_ value: Day)

    @objc(addListOfDays:)
    @NSManaged public func addToListOfDays(_ values: NSSet)

    @objc(removeListOfDays:)
    @NSManaged public func removeFromListOfDays(_ values: NSSet)

}

extension Focus : Identifiable {

}
