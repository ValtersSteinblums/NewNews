//
//  ViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 01/09/2022.
//

import UIKit
import SDWebImage
class NewsFeedViewController: UIViewController {
    
    var articles: [Article] = []
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NewsManager.shared.getTopStories { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchNews" {
            guard let searchVC = segue.destination as? SearchNewsViewController else {return}
            searchVC.delegate = self
        }
        
        if segue.identifier == "selectCategory" {
            guard let categoryVC = segue.destination as? NewsCategoryViewController else {return}
            categoryVC.delegate = self
        }
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsTableViewCell else {return UITableViewCell()}
        let item = articles[indexPath.row]
        cell.publishedLabel.text = item.publishedAt?.padding(toLength: 10, withPad: "", startingAt: 0)
        cell.newsImageView.sd_setImage(with: URL(string: item.urlToImage ?? ""))
        cell.authorlabel.text = item.source?.name
        cell.descriptionLabel.text = item.articleDescription
        
        return cell
    }
}

// MARK: - SearchNewsViewControllerDelegate
extension NewsFeedViewController: SearchNewsViewControllerDelegate {
    
    func refreshNewsFeed(searchQuery: String) {
        NewsManager.shared.searchNews(searchQuery: searchQuery) { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
}

// MARK: - NewsCategoryViewControllerDelegate
extension NewsFeedViewController: NewsCategoryViewControllerDelegate {
    func refreshNewsFeed(category: String) {
        NewsManager.shared.searchNews(category: category) { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
}

