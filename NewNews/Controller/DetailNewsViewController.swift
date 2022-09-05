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
    var savedArticleExists: Bool?
    
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if self.isFromViewController == "NewsFeed" {
            self.title = item?.author
            
            articleLabel.text = item?.articleDescription
            newsImage.sd_setImage(with: URL(string: item?.urlToImage ?? ""))
            sourceLabel.text = item?.source?.name
            dateLabel.text = item?.publishedAt?.description
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            managedObjectContext = appDelegate.persistentContainer.viewContext
            
            let alreadySaved = checkIfExists()
            changeFavouriteButtonState(isSaved: alreadySaved)
            
            print("HELLO FROM FEED")
        }
        
        
        if self.isFromViewController == "SavedNewsFeed" {
            
            
            articleLabel.text = saved?.newsDescription
            newsImage.sd_setImage(with: URL(string: saved?.newsImage ?? ""))
            sourceLabel.text = saved?.newsSource
            dateLabel.text = saved?.newsDate
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            managedObjectContext = appDelegate.persistentContainer.viewContext
            
            changeFavouriteButtonState(isSaved: true)
            
            print("HELLO FROM FAVES")
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
    
    //    https://stackoverflow.com/questions/37938722/how-to-implement-share-button-in-swift
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        if self.isFromViewController == "NewsFeed" {
            let shareNewsArticleVC = UIActivityViewController(activityItems: [item?.url ?? ""], applicationActivities: nil)
            shareNewsArticleVC.popoverPresentationController?.sourceView = sender
            present(shareNewsArticleVC, animated: true, completion: nil)
            shareNewsArticleVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed  {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        if self.isFromViewController == "SavedNewsFeed" {
            let shareNewsArticleVC = UIActivityViewController(activityItems: [saved?.newsURL ?? ""], applicationActivities: nil)
            shareNewsArticleVC.popoverPresentationController?.sourceView = sender
            present(shareNewsArticleVC, animated: true, completion: nil)
            shareNewsArticleVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
                if completed  {
                    self.dismiss(animated: true, completion: nil)
                }
            }
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
                    // when core data is empty, returns nil. Any workarounds...?
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
                print("REMOVE SAVE PRESSED: ", savedNews)
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
                print("SAVE PRESSED: ", savedNews)
            }
        }
        }
        if self.isFromViewController == "SavedNewsFeed" {
            let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
            do {
                // when core data is empty, returns nil. Any workarounds...?
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
            //            https://stackoverflow.com/questions/28760541/programmatically-go-back-to-previous-viewcontroller-in-swift
            _ = navigationController?.popViewController(animated: true)
            print("REMOVE SAVE PRESSED: ", savedNews)
        }
        self.saveData()
    }
    
    func checkIfExists() -> Bool {
        let request: NSFetchRequest<SavedNews> = SavedNews.fetchRequest()
        do {
            // when core data is empty, returns nil. Any workarounds...?
            if let result = try managedObjectContext?.fetch(request) {
                for savedNews in result as [NSManagedObject] {
                    if (savedNews.value(forKey: "newsTitle") as! String) == item?.title {
                        print("ALREADY EXISTS!!!")
                        savedArticleExists = true
                    } else {
                        savedArticleExists = false
                        print("GO AHEAD ADD TO FAVES!!!")
                    }
                }
            }
        } catch {
            print("Something went wrong comapring")
        }
        print(savedArticleExists ?? "HUH.. WHY NIL?")
        // probably this is not a good idea...
        return savedArticleExists ?? false
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
        
        
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dVC: WebViewController = segue.destination as? WebViewController else {return}
        
        if self.isFromViewController == "NewsFeed" {
            dVC.urlString = item?.url ?? ""
        } else {
            dVC.urlString = saved?.newsURL ?? ""
        }
        
    }
    
}
