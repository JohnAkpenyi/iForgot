//
//  Day+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 02/01/2022.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: Date?
    @NSManaged public var listOfActivities: [String]?
    @NSManaged public var origon: Focus?

}

extension Day{
    func setDate(date: Date){
        self.date = date
    }
    
    func getDate() -> Date {
        return self.date ?? Date()
    }
    
    func addActivity(activity: String){
        self.listOfActivities?.append(activity)
    }
    
    func setActivities(activities: [String]){
        self.listOfActivities = activities
    }
    
    func deleteActivity(activityToRemove: String){
        self.listOfActivities?.remove(at: (self.listOfActivities?.firstIndex(of: activityToRemove))!)
    }
    
    func getActivities()-> [String]{
        return self.listOfActivities ?? []
    }
    
    func getParent()-> Focus{
        return self.origon!
    }
}

extension Day : Identifiable {

}
