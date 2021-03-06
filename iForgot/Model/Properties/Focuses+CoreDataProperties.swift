//
//  Focuses+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 02/01/2022.
//
//

import Foundation
import CoreData


extension Focuses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Focuses> {
        return NSFetchRequest<Focuses>(entityName: "Focuses")
    }

    @NSManaged private var focuses: NSOrderedSet?

}

extension Focuses{
    func addFocus(focusToAdd: Focus){
        var array = self.focuses?.array as! [Focus]
        array.append(focusToAdd)
    }
    
    func setFocuses(focuses: NSOrderedSet) {
        self.focuses = focuses
    }
    
    func getFocuses() -> [Focus]{
        return self.focuses?.array as! [Focus]
    }
}

// MARK: Generated accessors for focuses
extension Focuses {

    @objc(insertObject:inFocusesAtIndex:)
    @NSManaged public func insertIntoFocuses(_ value: Focus, at idx: Int)

    @objc(removeObjectFromFocusesAtIndex:)
    @NSManaged public func removeFromFocuses(at idx: Int)

    @objc(insertFocuses:atIndexes:)
    @NSManaged public func insertIntoFocuses(_ values: [Focus], at indexes: NSIndexSet)

    @objc(removeFocusesAtIndexes:)
    @NSManaged public func removeFromFocuses(at indexes: NSIndexSet)

    @objc(replaceObjectInFocusesAtIndex:withObject:)
    @NSManaged public func replaceFocuses(at idx: Int, with value: Focus)

    @objc(replaceFocusesAtIndexes:withFocuses:)
    @NSManaged public func replaceFocuses(at indexes: NSIndexSet, with values: [Focus])

    @objc(addFocusesObject:)
    @NSManaged public func addToFocuses(_ value: Focus)

    @objc(removeFocusesObject:)
    @NSManaged public func removeFromFocuses(_ value: Focus)

    @objc(addFocuses:)
    @NSManaged public func addToFocuses(_ values: NSOrderedSet)

    @objc(removeFocuses:)
    @NSManaged public func removeFromFocuses(_ values: NSOrderedSet)

}

extension Focuses : Identifiable {

}
