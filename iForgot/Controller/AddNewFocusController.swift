//
//  AddNewFocusController.swift
//  iForgot
//
//  Created by John Akpenyi on 22/11/2021.
//

import UIKit
import Combine

class AddNewFocusController: UIViewController {

    let dm = DataManager()
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var pickColor: UIButton!
    
    let picker = UIColorPickerViewController()
    // Global declaration, to keep the subscription alive.
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the Initial Color of the Picker
        picker.selectedColor = self.view.backgroundColor!

        // Setting Delegate
        picker.delegate = self
        pickColor.isHidden = true
        pickColor.isEnabled = false
    }
    
    @IBAction func pickColor(_ sender: Any) {
        
        /*let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        
        //  Subscribing selectedColor property changes.
        self.cancellable = picker.publisher(for: \.selectedColor)
            .sink { color in
                
                //  Changing view color on main thread.
                DispatchQueue.main.async {
                    self.view.backgroundColor = color
                }
            }
        
        self.present(picker, animated: true, completion: nil)*/
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
        
        // Presenting the Color Picker
        self.present(picker, animated: true, completion: nil)
        
        //performSegue(withIdentifier: "openCalendarView", sender: self)
    }
    
    
    
    

}

extension AddNewFocusController: UIColorPickerViewControllerDelegate{
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
        print(self.dm.hexStringFromColor(color: viewController.selectedColor))
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        print(self.picker.selectedColor)
            self.view.backgroundColor = viewController.selectedColor
        
    }
}
