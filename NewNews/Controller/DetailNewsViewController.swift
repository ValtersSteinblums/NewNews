//
//  DetailNewsViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import UIKit

class DetailNewsViewController: UIViewController {

    var item: Article?
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsImage.sd_setImage(with: URL(string: item?.urlToImage ?? ""))
        dateLabel.text = item?.publishedAt
        sourceLabel.text = item?.source?.name
        articleLabel.text = item?.articleDescription
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
