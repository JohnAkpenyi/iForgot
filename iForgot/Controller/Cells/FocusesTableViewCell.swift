//
//  FocusesTableViewCell.swift
//  iForgot
//
//  Created by John Akpenyi on 03/01/2022.
//

import UIKit

class FocusesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(name: String) {
        self.labelTitle.text = name
    }

}
