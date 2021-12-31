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
    
    let dm = DataManager()
    /**an empty day variable, instead of making the showingDay variable nil, this one is used - to avoid errors**/
    let emptyDay = Day()
    /**The current focus**/
    var selectedFocus = Focus()
    /**The current date which has been selected**/
    var selectedDate = Date()
    /**The day variable (not a day as in monday, tuesday etc) - The current date which is being shown to the user  is the current day variable**/
    var showingDay = Day()
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activitiesTable: UITableView!

    @IBOutlet weak var focusTextField: UITextField!
    @IBOutlet weak var calendarViewBtn: UIButton!
    
    @IBOutlet weak var calendarViewHeight: NSLayoutConstraint!
    
    var settingsButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.dataSource = self
        calendar.delegate = self
        //Turn the selected view into a box rather than a circle
        calendar.appearance.borderRadius = 0
        //Make the default event dots orange when not selected, but will turn blue when deselected
        calendar.appearance.eventDefaultColor = UIColor.orange
        calendar.clipsToBounds = true
        
        activitiesTable.dataSource = self
        activitiesTable.delegate = self
        
        updateValues()
        
        showingDay = Day(context: dm.managedContext)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        settingsButton.setImage(UIImage(systemName: "gearshape", withConfiguration: largeConfig), for: .normal)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        settingsButton.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)

        var rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = settingsButton
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Set the table view title text as the current date
        let date = Date()
        calendar.select(date)
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "EEEE"
        
        let string = formatter.string(from: date)

        dateLabel.text = string
    
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsView" {
            let controller = segue.destination as! SettingsViewController
            controller.selectedFocus = self.selectedFocus
            controller.previousVC = (self.navigationController?.topViewController)!
        }
    }


    @objc func settingsPressed() {

        settingsButton.rotate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            self.performSegue(withIdentifier: "settingsView", sender: self)
        }
    }
    
    @objc func updateValues(){
        focusTextField.text = selectedFocus.getName()
    }
    
    
    @IBAction func toggleCalendarView(_ sender: Any) {

        if calendarViewBtn.imageView?.image == UIImage(systemName: "chevron.up"){
            calendar.setScope(.week, animated: true)
            calendarViewBtn.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        }else{
            calendar.setScope(.month, animated: true)
            calendarViewBtn.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        
        
        
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
            for i in self.selectedFocus.getDays(){
                if i.getDate() == self.selectedDate{
                    self.showingDay = i
                }
            }
            
            self.activitiesTable.reloadData()
            self.calendar.reloadData()

        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

extension CalendarView: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    //Need this here in order for calendar view to to shrink with animation
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarViewHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //Set the table view title text as the current date
        
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
        self.showingDay.setDate(date: date)
        
        //Loop through days in the array again to find the one just created
        for i in self.selectedFocus.getDays(){
            if i.getDate() == selectedDate{
                self.showingDay = i
            }
        }
        
        
        
        
        
        
        self.activitiesTable.reloadData()
        self.activitiesTable.fadeTransition(0.5)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        var num = 0
        
        //Loop through days in the array to find the one which is being created
        for i in self.selectedFocus.getDays(){
            
            //Check if i has the same date as the ones which are being shown.
            if i.getDate() == date{
                
                switch i.getActivities().count{
                case 0:
                    num = 0
                case 1:
                    num = 1
                case 2:
                    num = 2
                case 3:
                    num = 3
                default:
                    num = 3
                }
                
            }
        }
        
        return num
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

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2
        rotation.isCumulative = true
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}



extension CalendarView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showingDay.getActivities().count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let customcell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ActivitiesTableViewCell{
            
            customcell.configure(name: showingDay.getActivities()[indexPath.row] )
            
            cell = customcell
        }
        
        /*var content = cell.defaultContentConfiguration()
        
        content.text = showingDay.listOfActivities?[indexPath.row]
        
        cell.contentConfiguration = content*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            showingDay.deleteActivity(activityToRemove: showingDay.getActivities()[indexPath.row])
            dm.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
}
