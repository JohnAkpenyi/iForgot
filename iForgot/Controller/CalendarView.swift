//
//  CalendarView.swift
//  iForgot
//
//  Created by John Akpenyi on 23/10/2021.
//

import UIKit
import FSCalendar
import CoreData

class CalendarView: UIViewController{
    
    var selectedFocus = Focus()
    
    let dm = DataManager()
    var selectedDate = Date()
    var showingDay = Day()
    let emptyDay = Day()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activitiesTable: UITableView!
    @IBOutlet weak var focusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self
        activitiesTable.dataSource = self
        activitiesTable.delegate = self
        
        focusTextField.text = selectedFocus.name
        
        showingDay = Day(context: dm.managedContext)
        
        
        //print(showingDay)
    }
    

    @IBAction func addActivity(_ sender: Any) {
 
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "New Activity", message: "Name this activity", preferredStyle: .alert)

        alertController.addTextField { (textField) in
            // configure the properties of the text field
            textField.placeholder = "..."
        }


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in

            // this code runs when the user hits the "save" button
            
            // tht text in the textfield
            let inputName = alertController.textFields![0].text
            
            //Add the activity to the date (it'll create a new day object if there are no activities )
            self.dm.addActivity(focus: self.selectedFocus, day: self.showingDay, activity: inputName ?? "")
            
            //Loop through days in the array again to find the one just created
            for i in (self.selectedFocus.listOfDays?.array as! [Day]){
                if i.date == self.selectedDate{
                    self.showingDay = i
                }
            }
            
            self.activitiesTable.reloadData()

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension CalendarView: FSCalendarDataSource, FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE dd-MM-YYYY"
        
        let string = formatter.string(from: date)
        
        print("\(string)")
        
        dateLabel.fadeTransition(0.5)
        dateLabel.text = string
        
        
        // turn the selected date into a global variable
        self.selectedDate = date
        
        //the global variable for the day object thats showing on the screen
        self.showingDay = Day(context: dm.managedContext)
        self.showingDay.date = date
        
        //Loop through days in the array again to find the one just created
        for i in (self.selectedFocus.listOfDays?.array as! [Day]){
            if i.date == selectedDate{
                self.showingDay = i
            }
        }
        
        self.activitiesTable.reloadData()
        self.activitiesTable.fadeTransition(0.5)
    }
    
    
}

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}


extension CalendarView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showingDay.listOfActivities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var content = cell.defaultContentConfiguration()
        
        content.text = showingDay.listOfActivities?[indexPath.row]
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    
}
