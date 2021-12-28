//
//  ActivitiesTableViewCell.swift
//  iForgot
//
//  Created by John Akpenyi on 28/12/2021.
//

import UIKit

class ActivitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var bulletPointImg: UIImageView!
    @IBOutlet weak var cellText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name:String) {
        self.cellText.text = name
    }
}
