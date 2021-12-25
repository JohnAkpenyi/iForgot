//
//  DataManager.swift
//  iForgot
//
//  Created by John Akpenyi on 06/11/2021.
//

import Foundation
import CoreData
import UIKit

class DataManager{
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var focuses = Focuses()
    var fEmpty = true
    
    init() {
        self.createFirstFocuses()
        self.load()
    }
        
    func createFirstFocuses() {
        let fetchRequest: NSFetchRequest<Focuses> = Focuses.fetchRequest()
        
        // Perform Fetch Request
        managedContext.perform {
            do {
                // Execute Fetch Request
                let result = try fetchRequest.execute()
                
                if result.isEmpty{
                    let entry_focuses_entity = NSEntityDescription.insertNewObject(forEntityName: "Focuses", into: self.managedContext)
                    
                    self.managedContext.insert(entry_focuses_entity)
                    do {
                        try self.managedContext.save()
                        self.load()
                         } catch {
                               print("Failed saving car details")
                         }
                }
       

            } catch {
                print("Unable to Execute Fetch Request, \(error)")
            }
        }
    }
    
    func addFocus(focusName: String){
    
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Focuses")
        
        let focus_entity = NSEntityDescription.entity(forEntityName: "Focus", in: managedContext)
        let focus = Focus(entity: focus_entity!, insertInto: managedContext)
        focus.name = focusName
        focus.listOfDays = NSOrderedSet(array: [])
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let objectUpdate = result[0] as! Focuses
            //objectUpdate.setValue(NSSet(array: [focus]), forKey: "focuses")
            objectUpdate.addToFocuses(focus)
            try managedContext.save() // look in AppDelegate.swift for this function
            self.load()
        } catch {
          print("error finding or saving focuses \(error)")
        }
        
    }
    
    func addDay(focus: Focus, date: Date, activities: [String]){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Focuses")
        
        let day_entity = NSEntityDescription.entity(forEntityName: "Day", in: managedContext)
        let day = Day(entity: day_entity!, insertInto: managedContext)
        
        day.date = date
        day.listOfActivities = activities
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let objectUpdate = result[0] as! Focuses
            let index = (objectUpdate.focuses?.array as! [Focus]).firstIndex(of: focus)! //May be error here
            (objectUpdate.focuses?.array as! [Focus])[index].addToListOfDays(day)
            try managedContext.save()
            self.load()
        }catch{
            print("error finding or saving focuses \(error)")
        }
        
        
    }
    
    
    func load(){
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Focuses")

        do{
            let result = try managedContext.fetch(fetchRequest)
            if result.isEmpty == false{
                self.focuses = result[0] as! Focuses
                self.fEmpty = false
            }else{
                self.fEmpty = true
            }
        }catch{
            print("Error loading data")
        }
    }

}
