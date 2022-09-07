//
//  NewsCategoryViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 03/09/2022.
//

import UIKit

protocol NewsCategoryViewControllerDelegate {
    func refreshNewsFeed(category: String)
}

class NewsCategoryViewController: UIViewController {
    
    let categories = [
        "General",
        "Business",
        "Entertainment",
        "Health",
        "Science",
        "Sports",
        "Technology"
    ]

    var delegate: NewsCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension NewsCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let categoryList = categories[indexPath.row]
        cell.textLabel?.text = categoryList.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        let whatCategory = selectedCategory.description
        delegate?.refreshNewsFeed(category: whatCategory)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
