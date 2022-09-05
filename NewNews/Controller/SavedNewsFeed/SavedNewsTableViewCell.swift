//
//  SavedNewsTableViewCell.swift
//  NewNews
//
//  Created by valters.steinblums on 05/09/2022.
//

import UIKit

class SavedNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var savedTitleLabel: UILabel!
    @IBOutlet weak var savedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
