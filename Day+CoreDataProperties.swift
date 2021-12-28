//
//  Day+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 07/12/2021.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged private var date: Date?
    @NSManaged private var listOfActivities: [String]?
    @NSManaged private var origon: Focus?
    
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
