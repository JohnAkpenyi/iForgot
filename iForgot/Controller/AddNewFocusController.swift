//
//  AddNewFocusController.swift
//  iForgot
//
//  Created by John Akpenyi on 22/11/2021.
//

import UIKit

class AddNewFocusController: UIViewController, UITextFieldDelegate{

    let dm = DataManager()
    @IBOutlet weak var focusNameView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var createBtn: UIButton!

    @IBOutlet weak var reminderOnView: UIView!
    @IBOutlet weak var question1Label: UILabel!
    
    @IBOutlet weak var reminderDetailsView: UIView!
    @IBOutlet weak var timePickerView: UIDatePicker!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var repeatSwitcher: UISwitch!
    @IBOutlet weak var noBtn: UIButton!
    
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderOnView.isHidden = true
        reminderDetailsView.isHidden = true
        
        nameField.delegate = self
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: nameField.frame.height - 1, width: nameField.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.label.cgColor
        nameField.borderStyle = UITextField.BorderStyle.none
        nameField.layer.addSublayer(bottomLine)
        
   
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func YesPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.reminderOnView.alpha = 0.0
            self.reminderDetailsView.alpha = 0.0
                    }, completion: {
                        (finished: Bool) -> Void in
        
                        //Once the view is completely invisible, unhide the next view and fade it back in
                        self.reminderOnView.isHidden = true
                        self.reminderDetailsView.isHidden = false
        
                        // Fade in
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            self.reminderDetailsView.alpha = 1.0
                            }, completion: nil)
                })
        
    }
    
    @IBAction func NoPressed(_ sender: Any) {
        
        dm.addFocus(focusName: nameField.text ?? "No name found")
        dm.load()
        //print(dm.focuses)
        noBtn.isEnabled = false
        
        
        
        
        let duration: TimeInterval = 1.0
                UIView.animate(withDuration: duration, animations: {
                    self.createBtn.frame.origin.x = 300
                    self.createBtn.frame.origin.y = -50
                    }, completion: nil)
        
        let secondsToDelay = 0.6
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    
    
    @IBAction func createFocusRE(_ sender: Any) {
        
        let d = datePickerView.date
        
        let date = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: timePickerView.date), minute: Calendar.current.component(.minute, from: timePickerView.date), second: 0, of: d)!
        
        dm.addFocusRE(focusName: nameField.text ?? "No name", reminderOn: true, reminderRepeat: repeatSwitcher.isOn, reminderDT: date, notificationID: scheduleNotification(weekday: Calendar.current.component(.weekday, from: date), hour: Calendar.current.component(.hour, from: date), minute: Calendar.current.component(.minute, from: date), shouldRepeat: repeatSwitcher.isOn))
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        if nameField.text?.isEmpty == true {
            showAlertMsg(title: "No Name Found", message: "Please enter a name", time: 2)
        }else{
            question1Label.text = "Do you want to be reminded to focus on '\(nameField.text ?? "No name")' ?"
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                        self.focusNameView.alpha = 0.0
                self.reminderOnView.alpha = 0.0
                        }, completion: {
                            (finished: Bool) -> Void in
            
                            //Once the view is completely invisible, unhide the next view and fade it back in
                            self.focusNameView.isHidden = true
                            self.reminderOnView.isHidden = false
            
                            // Fade in
                            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                                self.reminderOnView.alpha = 1.0
                                }, completion: nil)
                    })
        }
 
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
        content.body = "When was the last time you focused on \(nameField.text!)? 🧘‍♂️"
        
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


