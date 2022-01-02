//
//  Focus+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 02/01/2022.
//
//

import Foundation
import CoreData


extension Focus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Focus> {
        return NSFetchRequest<Focus>(entityName: "Focus")
    }

    @NSManaged public var name: String?
    @NSManaged public var remindersOn: Bool
    @NSManaged public var reminderDT: Date?
    @NSManaged public var reminderRepeat: Bool
    @NSManaged public var notificationID: String?
    @NSManaged public var listOfDays: NSOrderedSet?
    @NSManaged public var origon: Focuses?

}

extension Focus{
    func setName(name: String) {
        self.name = name
    }
    
    func getName() -> String{
        self.name ?? "Error getting name"
    }
    
    func setNotificationID(identifier: String){
        self.notificationID = identifier
    }
    
    func getNotificationID() -> String{
        return self.notificationID ?? "None found"
    }
    
    func setReminderOn(reminderOn: Bool){
        self.remindersOn = reminderOn
    }
    
    func getReminderOn() -> Bool{
        return self.remindersOn
    }
    
    func setReminderDT(reminderDateTime: Date){
        self.reminderDT = reminderDateTime
    }
    
    func getReminderDT() -> Date{
        return self.reminderDT ?? Date()
    }
    
    func setReminderRepeat(reminderRepeat: Bool){
        self.reminderRepeat = reminderRepeat
    }
    
    func getReminderRepeat() -> Bool{
        return self.reminderRepeat
    }

    func addDay(dayToAdd: Day){
        var array = self.listOfDays?.array as! [Day]
        array.append(dayToAdd)
    }
    
    func setDays(days: NSOrderedSet) {
        self.listOfDays = days
    }

    func getDays() -> [Day]{
        return self.listOfDays?.array as! [Day]
    }
    
    func getParent() -> Focuses{
        return self.origon!
    }
}

// MARK: Generated accessors for listOfDays
extension Focus {

    @objc(insertObject:inListOfDaysAtIndex:)
    @NSManaged public func insertIntoListOfDays(_ value: Day, at idx: Int)

    @objc(removeObjectFromListOfDaysAtIndex:)
    @NSManaged public func removeFromListOfDays(at idx: Int)

    @objc(insertListOfDays:atIndexes:)
    @NSManaged public func insertIntoListOfDays(_ values: [Day], at indexes: NSIndexSet)

    @objc(removeListOfDaysAtIndexes:)
    @NSManaged public func removeFromListOfDays(at indexes: NSIndexSet)

    @objc(replaceObjectInListOfDaysAtIndex:withObject:)
    @NSManaged public func replaceListOfDays(at idx: Int, with value: Day)

    @objc(replaceListOfDaysAtIndexes:withListOfDays:)
    @NSManaged public func replaceListOfDays(at indexes: NSIndexSet, with values: [Day])

    @objc(addListOfDaysObject:)
    @NSManaged public func addToListOfDays(_ value: Day)

    @objc(removeListOfDaysObject:)
    @NSManaged public func removeFromListOfDays(_ value: Day)

    @objc(addListOfDays:)
    @NSManaged public func addToListOfDays(_ values: NSOrderedSet)

    @objc(removeListOfDays:)
    @NSManaged public func removeFromListOfDays(_ values: NSOrderedSet)

}

extension Focus : Identifiable {

}
