//
//  FocusesController.swift
//  iForgot
//
//  Created by John Akpenyi on 06/11/2021.
//

import UIKit
import CoreData

class FocusesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Focuses")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let focuses = data.value(forKey: "focuses") as! NSSet
                let f = focuses.allObjects as! [Focus]
                
                if f.isEmpty{
                    performSegue(withIdentifier: "openNewFocus", sender: self)
                }else{
                    
                }
                
            }
        } catch {
            print("Fetching data Failed")
        }
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
