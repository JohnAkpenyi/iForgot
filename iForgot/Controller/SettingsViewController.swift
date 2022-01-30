//
//  SettingsViewController.swift
//  iForgot
//
//  Created by John Akpenyi on 30/12/2021.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController{
    
    let dm = DataManager()
    var selectedFocus = Focus()
    @IBOutlet weak var focusName: UITextField!
    var previousVC = UIViewController()
    @IBOutlet weak var deleteBtn: UIButton!
    
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var remindersToggle: UISwitch!
    @IBOutlet weak var remindersDateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatText: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusName.delegate = self
        
        focusName.text = selectedFocus.getName()
        remindersToggle.isOn = selectedFocus.getReminderOn()
        
        datePicker.date = selectedFocus.getReminderDT()
        timePicker.date = selectedFocus.getReminderDT()
        repeatText.isOn = selectedFocus.getReminderRepeat()
        
        if !selectedFocus.getReminderOn() {
            remindersDateLabel.textColor = UIColor.placeholderText
            datePicker.isEnabled = false
            timeLabel.textColor = UIColor.placeholderText
            timePicker.isEnabled = false
            repeatLabel.textColor = UIColor.placeholderText
            repeatText.isEnabled = false
        }
        
        stackView.layer.cornerRadius = 10
        
        //scheduleNotification()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }

    @IBAction func RemindersTogglePressed(_ sender: Any) {
        if remindersToggle.isOn {
            remindersDateLabel.textColor = UIColor.label
            datePicker.isEnabled = true
            repeatLabel.textColor = UIColor.label
            repeatText.isEnabled = true
            timeLabel.textColor = UIColor.label
            timePicker.isEnabled = true
        }else{
            remindersDateLabel.textColor = UIColor.placeholderText
            datePicker.isEnabled = false
            repeatLabel.textColor = UIColor.placeholderText
            repeatText.isEnabled = false
            timeLabel.textColor = UIColor.placeholderText
            timePicker.isEnabled = false
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.previousVC.viewDidLoad()
        })
    }
    
    
    @IBAction func deleteFocusPressed(_ sender: Any) {
        // create the actual alert controller view that will be the pop-up
        let alertController = UIAlertController(title: "Are you sure you want to delete this Focus?", message: "You won't be able to recover it later", preferredStyle: .alert)


        // add the buttons/actions to the view controller
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Yes", style: .default) { _ in
            
            self.dm.focuses.removeFromFocuses(self.selectedFocus)
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers:[self.selectedFocus.getNotificationID()])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.selectedFocus.getNotificationID()])
            self.dm.save()
            
            self.previousVC.navigationController?.popViewController(animated: true)
            self.dismissView(self)
            
            
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func saveChanges(_ sender: Any) {
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [selectedFocus.getNotificationID()])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [selectedFocus.getNotificationID()])
        
        
        
        let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)

        let hour = calendar.component(.hour, from: timePicker.date)
        let minute = calendar.component(.minute, from: timePicker.date)
        let weekday = calendar.component(.weekday, from: datePicker.date)
        
        
        if remindersToggle.isOn {
            if repeatText.isOn{
                
                let d = datePicker.date
                
                let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: d)!
                
                selectedFocus.setName(name: focusName.text ?? selectedFocus.getName())
                selectedFocus.setReminderOn(reminderOn: remindersToggle.isOn)
                selectedFocus.setReminderRepeat(reminderRepeat: repeatText.isOn)
                selectedFocus.setReminderDT(reminderDateTime: date)
                selectedFocus.setNotificationID(identifier: scheduleNotification(weekday: weekday, hour: hour, minute: minute, shouldRepeat: true))
 
                
                dm.save()
                
            }else{
                
                let d = datePicker.date
                
                let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: d)!
                
                selectedFocus.setName(name: focusName.text ?? selectedFocus.getName())
                selectedFocus.setReminderOn(reminderOn: remindersToggle.isOn)
                selectedFocus.setReminderRepeat(reminderRepeat: repeatText.isOn)
                selectedFocus.setReminderDT(reminderDateTime: date)
                selectedFocus.setNotificationID(identifier: scheduleNotification(weekday: weekday, hour: hour, minute: minute, shouldRepeat: false))
                
                dm.save()
            }
        }else{

            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [selectedFocus.getNotificationID()])
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [selectedFocus.getNotificationID()])

        }
        
        self.showAlertMsg(title: "✔", message: "Changes Saved ", time: 1)
        
        previousVC.viewDidLoad()
        
    }
    
    func showAlertMsg(title: String, message: String, time: Int) {

        guard (self.alertController == nil) else {
                print("Alert already displayed")
                return
            }

            self.baseMessage = message
            self.remainingTime = time

        self.alertController = UIAlertController(title: title, message: self.alertMessage(), preferredStyle: .alert)
        
    
        self.alertTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)

            self.present(self.alertController!, animated: true, completion: nil)
        }

    @objc func countDown() {

            self.remainingTime -= 1
            if (self.remainingTime < 0) {
                self.alertTimer?.invalidate()
                self.alertTimer = nil
                self.alertController!.dismiss(animated: true, completion: {
                    self.alertController = nil
                })
            } else {
                self.alertController!.message = self.alertMessage()
            }

        }

    func alertMessage() -> String {
            var message=""
            if let baseMessage=self.baseMessage {
                message=baseMessage+" "
            }
            return(message)
        }
    
    func scheduleNotification(weekday: Int, hour: Int, minute: Int, shouldRepeat: Bool) -> String{
        let content = UNMutableNotificationContent()
        content.title = "iForgot"
        content.body = "When was the last time you focused on \(selectedFocus.getName())? 🧘‍♂️"
        
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.weekday = weekday  // Friday
        dateComponents.hour = hour    // 14:00 hours
        dateComponents.minute = minute
        
        let uuidString = UUID().uuidString
        
        if shouldRepeat {
            // Create the trigger as a repeating event.
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: true)
            
            // Create the request
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
                   print(error!)
               }
            }
        }else{
            // Create the trigger as a non repeating event.
            let trigger = UNCalendarNotificationTrigger(
                     dateMatching: dateComponents, repeats: false)
            
            // Create the request
            let request = UNNotificationRequest(identifier: uuidString,
                        content: content, trigger: trigger)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
               if error != nil {
                  // Handle any errors.
                   print(error!)
               }
            }
        }
        
        
        return uuidString
       
    }
    
    
    


}

extension SettingsViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
