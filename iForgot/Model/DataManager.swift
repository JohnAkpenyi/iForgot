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
        focus.setName(name: focusName)
        focus.setReminderOn(reminderOn: false)
        focus.setReminderRepeat(reminderRepeat: false)
        //focus.listOfDays = NSOrderedSet(array: [])
        
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
        
        day.setDate(date: date)
        day.setActivities(activities: activities)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let objectUpdate = result[0] as! Focuses
            let index = objectUpdate.getFocuses().firstIndex(of: focus)! //May be error here
            objectUpdate.getFocuses()[index].addToListOfDays(day)
            try managedContext.save()
            self.load()
        }catch{
            print("error finding or saving focuses \(error)")
        }
    }
    
    func addActivity(focus: Focus, day: Day, activity: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Focuses")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let objectUpdate = result[0] as! Focuses
            
            //find the index of the current focus
            let index = objectUpdate.getFocuses().firstIndex(of: focus)! //May be error here
            
            //list of days of the current focus
            let days = objectUpdate.getFocuses()[index].getDays()
            
            //find the index of the day we are looking for
            let d_index = days.firstIndex(of: day)
            
            //the index might be nil since the day may not have been created yet
            if d_index == nil{
                
                //create a day and add the activity
                self.addDay(focus: focus, date: day.getDate(), activities: [activity])
            }else{
                //add the activity to the list of activities for that specific day and focus
                days[d_index!].addActivity(activity: activity)
            }
            try managedContext.save()
            self.load()
        }catch{
            print("error finding or saving focuses \(error)")
        }
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
    
    func colorWithHexString(hexString: String) -> UIColor {
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()

        print(colorString)
        let alpha: CGFloat = 1.0
        let red: CGFloat = self.colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
        let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt32 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt32(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        print(floatValue)
        return floatValue
    }
    
    func save(){
        do{
            try self.managedContext.save()
            load()
        }catch{
            print(error)
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
