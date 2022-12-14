//
//  DetailNewsViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import UIKit
import CoreData

class DetailNewsViewController: UIViewController {
    
    var item: Article?
    var saved: SavedNews?
    var savedNews = [SavedNews]()
    var isFromViewController: String = ""
    //var savedArticleExists: Bool?
    
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.isFromViewController == "NewsFeed" {
            articleLabel.text = item?.articleDescription
            newsImage.sd_setImage(with: URL(string: item?.urlToImage ?? ""))
            sourceLabel.text = item?.source?.name
            dateLabel.text = item?.publishedAt?.description.padding(toLength: 10, withPad: "", startingAt: 0)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            managedObjectContext = appDelegate.persistentContainer.viewContext
            
            let alreadySaved = checkIfExists()
            changeFavouriteButtonState(isSaved: alreadySaved)
        }
        
        
        if self.isFromViewController == "SavedNewsFeed" {
            articleLabel.text = saved?.newsDescription
            newsImage.sd_setImage(with: URL(string: saved?.newsImage ?? ""))
            sourceLabel.text = saved?.newsSource
            dateLabel.text = saved?.newsDate?.padding(toLength: 10, withPad: "", startingAt: 0)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            managedObjectContext = appDelegate.persistentContainer.viewContext
            
            changeFavouriteButtonState(isSaved: true)
        }
        
        loadData()
    }
    
    func loadData() {
        let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
        
        do {
            if let result = try managedObjectContext?.fetch(request) {
                savedNews = result
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
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if self.isFromViewController == "NewsFeed" {
            shareView(activityItems: [item?.url ?? ""], sender: sender)
        }
        if self.isFromViewController == "SavedNewsFeed" {
            shareView(activityItems: [saved?.newsURL ?? ""], sender: sender)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        loadData()
        if self.isFromViewController == "NewsFeed" {
            let alreadySaved = checkIfExists()
            switch alreadySaved {
            case true:
                let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
                do {
                    if let result = try managedObjectContext?.fetch(request) {
                        for savedNews in result as [NSManagedObject] {
                            if (savedNews.value(forKey: "newsTitle") as! String) == item?.title {
                                managedObjectContext?.delete(savedNews)
                            }
                        }
                    }
                } catch {
                    print("Something went wrong removing favourites from detail view")
                }
                changeFavouriteButtonState(isSaved: false)
            case false:
                if let entity = NSEntityDescription.entity(forEntityName: "SavedNews", in: self.managedObjectContext!) {
                    let article = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
                    article.setValue(item?.articleDescription, forKey: "newsDescription")
                    article.setValue(item?.title, forKey: "newsTitle")
                    article.setValue(item?.urlToImage, forKey: "newsImage")
                    article.setValue(item?.url, forKey: "newsURL")
                    article.setValue(item?.source?.name, forKey: "newsSource")
                    article.setValue(item?.publishedAt?.description, forKey: "newsDate")
                    changeFavouriteButtonState(isSaved: true)
                }
            }
        }
        if self.isFromViewController == "SavedNewsFeed" {
            let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
            do {
                if let result = try managedObjectContext?.fetch(request) {
                    for savedNews in result as [NSManagedObject] {
                        if (savedNews.value(forKey: "newsTitle") as! String) == saved?.newsTitle {
                            managedObjectContext?.delete(savedNews)
                        }
                    }
                }
            } catch {
                print("Something went wrong removing favourites from detail view")
            }
            changeFavouriteButtonState(isSaved: false)
            _ = navigationController?.popViewController(animated: true)
        }
        self.saveData()
    }
    
    func checkIfExists() -> Bool {
        let fetchRequest: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "newsTitle == %@", item?.title ?? "")
        
        do {
            let count = try managedObjectContext?.count(for: fetchRequest)
            if count! > 0 {
                return true
            } else {
                return false
            }
        } catch {
            print("Could not fetch")
            return false
        }
    }
    
    func changeFavouriteButtonState(isSaved: Bool) {
        switch isSaved {
        case true:
            saveButton.setImage(UIImage.init(systemName: "heart.fill"), for: .normal)
        case false:
            saveButton.setImage(UIImage.init(systemName: "heart"), for: .normal)
        }
        saveData()
    }
    
    func shareView(activityItems: [Any], sender: UIButton) {
        let shareNewsArticleVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        shareNewsArticleVC.popoverPresentationController?.sourceView = sender
        present(shareNewsArticleVC, animated: true, completion: nil)
        shareNewsArticleVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed  {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dVC: WebViewController = segue.destination as? WebViewController else {return}
        if self.isFromViewController == "NewsFeed" {
            dVC.urlString = item?.url ?? ""
        } else {
            dVC.urlString = saved?.newsURL ?? ""
        }
        
    }
    
}
