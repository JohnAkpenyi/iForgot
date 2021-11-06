//
//  Focus+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 05/11/2021.
//
//

import Foundation
import CoreData


extension Focus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Focus> {
        return NSFetchRequest<Focus>(entityName: "Focus")
    }

    @NSManaged public var focusName: String?
    @NSManaged public var days: NSSet?
    @NSManaged public var origon: Focuses?
    
    public var wrappedName: String{
        focusName ?? "Unknown Focus"
    }
    
    public var dayArray: [Day] {
        let set = days as? Set<Day> ?? []
        
        return set.sorted{
            $0.wrappedDate < $1.wrappedDate
        }
    }
    
}

// MARK: Generated accessors for days
extension Focus {

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: Day)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: Day)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSSet)

}

extension Focus : Identifiable {

}
