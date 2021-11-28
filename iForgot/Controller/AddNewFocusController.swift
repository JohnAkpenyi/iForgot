//
//  AddNewFocusController.swift
//  iForgot
//
//  Created by John Akpenyi on 22/11/2021.
//

import UIKit

class AddNewFocusController: UIViewController {

    let dm = DataManager()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //performSegue(withIdentifier: "openCalendarView", sender: nil)
        // Do any additional setup after loading the view.
        
    }
    

    @IBAction func createBtnPressed(_ sender: Any) {
        
        dm.addFocus(focusName: nameField.text ?? "No name found")
        dm.load()
        //print(dm.focuses)
        
        
        
        
        let duration: TimeInterval = 1.0
                UIView.animate(withDuration: duration, animations: {
                    self.createBtn.frame.origin.x = 300
                    self.createBtn.frame.origin.y = -50
                    }, completion: nil)
        
        let secondsToDelay = 0.6
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.navigationController?.popViewController(animated: false)
        }
        
        
        //performSegue(withIdentifier: "openCalendarView", sender: self)
    }
    
    

}
