//
//  Focuses+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 05/11/2021.
//
//

import Foundation
import CoreData


extension Focuses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Focuses> {
        return NSFetchRequest<Focuses>(entityName: "Focuses")
    }

    @NSManaged public var focuses: NSSet?

    
    public var focusesArray: [Focus] {
        let set = focuses as? Set<Focus> ?? []
        
        return set.sorted{
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for focuses
extension Focuses {

    @objc(addFocusesObject:)
    @NSManaged public func addToFocuses(_ value: Focus)

    @objc(removeFocusesObject:)
    @NSManaged public func removeFromFocuses(_ value: Focus)

    @objc(addFocuses:)
    @NSManaged public func addToFocuses(_ values: NSSet)

    @objc(removeFocuses:)
    @NSManaged public func removeFromFocuses(_ values: NSSet)

}

extension Focuses : Identifiable {

}
