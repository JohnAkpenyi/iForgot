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
        
        print(showingDay)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarView: FSCalendarDataSource, FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE dd-MM-YYYY"
        
        let string = formatter.string(from: date)
        
        print("\(string)")
        
        dateLabel.fadeTransition(0.5)
        dateLabel.text = string
        
        /*for i in 0...4{
            dm.addDay(focus: dm.focuses.focuses?.allObjects[i] as! Focus, date: date, activities: ["Did pushups", "Did weights"])
        }*/
        
        
        print((self.selectedFocus.listOfDays?.allObjects as! [Day])[0])
        
        selectedDate = date
        
        showingDay.listOfActivities = []
        
        for i in selectedFocus.listOfDays?.allObjects as! [Day]{
            if i.date == selectedDate{
               showingDay = i
            }
        }
        
        self.activitiesTable.reloadData()
        
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
