//
//  NewsTableViewCell.swift
//  NewNews
//
//  Created by valters.steinblums on 02/09/2022.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var authorlabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
