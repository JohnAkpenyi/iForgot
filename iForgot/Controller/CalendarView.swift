//
//  CalendarView.swift
//  iForgot
//
//  Created by John Akpenyi on 23/10/2021.
//

import UIKit
import FSCalendar

class CalendarView: UIViewController{
    

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self

        // Do any additional setup after loading the view.
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
