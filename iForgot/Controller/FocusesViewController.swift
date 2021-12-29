//
//  FocusesViewController.swift
//  iForgot
//
//  Created by John Akpenyi on 23/10/2021.
//

import UIKit

class FocusesViewController: UIViewController {

    let dm = DataManager()
    @IBOutlet weak var focusesTable: UITableView!
    @IBOutlet weak var newFocusLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var addfocusBtn: UIBarButtonItem!
    @IBOutlet weak var focusesTitle: UIBarButtonItem!
    var selectedFocus = Focus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dm.createFirstFocuses()
        
        focusesTable.dataSource = self
        focusesTable.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.focusesTable.reloadData()
        
        if dm.fEmpty || dm.focuses.getFocuses().count == 0{
            plusBtn.isHidden = false
            newFocusLabel.isHidden = false
            focusesTable.isHidden = true
            addfocusBtn.customView?.isHidden = true
            focusesTitle.customView?.isHidden = true
        }else{
            plusBtn.isHidden = true
            newFocusLabel.isHidden = true
            focusesTable.isHidden = false
            addfocusBtn.customView?.isHidden = false
            focusesTitle.customView?.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCalendarFocus" {
                    let controller = segue.destination as! CalendarView
            controller.selectedFocus = self.selectedFocus
            }
    }
    
    
    @IBAction func addNewFocuses(_ sender: Any) {
        dm.load()
    }
    
  

}

extension FocusesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if dm.fEmpty{
            return 0
        }else{
            return dm.focuses.getFocuses().count ?? 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        content.text = dm.focuses.getFocuses()[indexPath.row].getName()

        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pos = focusesTable.cellForRow(at: indexPath)
        
        for i in dm.focuses.getFocuses(){ // may be error due to !
            if i.getName() == (pos?.contentConfiguration as! UIListContentConfiguration).text{ //deprecated
                let viewController = CalendarView()
                selectedFocus = i
                performSegue(withIdentifier: "openCalendarFocus", sender: self)
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            dm.focuses.removeFromFocuses(dm.focuses.getFocuses()[indexPath.row])
            dm.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            self.viewWillAppear(true)
        }
        
    }
    
}
