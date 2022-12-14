//
//  SavedNewsTableViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 05/09/2022.
//

import UIKit
import CoreData
import SDWebImage

class SavedNewsTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext?
    var savedNews = [SavedNews]()
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "rowOrder", ascending: true)]
            
            if let result = try managedObjectContext?.fetch(request) {
                savedNews = result
                self.tableView.reloadData()
            }
        } catch {
            print("Error in loading core data items.")
        }
    }
    
    func saveData() {
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error in loading core data items.")
        }
        loadData()
    }

    @IBAction func deleteAllButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete all saved News articles?", message: "Do you really want to delete all saved News articles from the list?", preferredStyle: .alert)

        let addDeleteButton = UIAlertAction(title: "Delete", style: .destructive) { action in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedNews")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try self.managedObjectContext?.execute(batchDeleteRequest)
            } catch {
                print("Error in the batch delete!!!")
            }
            self.saveData()
        }

        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alertController.addAction(addDeleteButton)
        alertController.addAction(cancelButton)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditing = !isEditing
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if savedNews.count == 0 {
            tableView.setEmptyView(title: "No favourites to show for now.", messageImage: UIImage(named: "HeartB")!, message: "Once you favourite a news article, it will appear here!")
        }
        
        return savedNews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if savedNews.count != 0 {
            tableView.backgroundView?.isHidden = true
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedNewsCell", for: indexPath) as? SavedNewsTableViewCell else {return UITableViewCell()}
        
        let savedArticle = savedNews[indexPath.row]
        cell.savedImageView.sd_setImage(with: URL(string: savedArticle.value(forKey: "newsImage") as? String ?? ""))
        cell.savedTitleLabel.text = savedArticle.value(forKey: "newsTitle") as? String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "DetailNewsViewController") as? DetailNewsViewController else {return}
        let savedArticle = savedNews[indexPath.row]
        newsDetailVC.saved = savedArticle
        newsDetailVC.isFromViewController = "SavedNewsFeed"
        show(newsDetailVC, sender: self)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(savedNews[indexPath.row])
        }
        saveData()
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let newsArticleToMove = savedNews[fromIndexPath.row]
        
        savedNews.remove(at: fromIndexPath.row)
        savedNews.insert(newsArticleToMove, at: destinationIndexPath.row)
        
        for (newValue, item) in savedNews.enumerated() {
            item.setValue(newValue, forKey: "rowOrder")
        }
        
        tableView.reloadData()
        saveData()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
