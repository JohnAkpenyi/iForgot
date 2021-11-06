//
//  Day+CoreDataProperties.swift
//  iForgot
//
//  Created by John Akpenyi on 05/11/2021.
//
//

import Foundation
import CoreData


extension Day {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var activitiesDone: String?
    @NSManaged public var date: Date?
    @NSManaged public var origon: Focus?
    
    public var wrappedDate: Date{
        date!
    }
    
    public func addActivity(activity: String){
        activitiesDone = activitiesDone ?? "" + activity + ","
        
    }

}

extension Day : Identifiable {

}
