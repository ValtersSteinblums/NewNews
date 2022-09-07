//
//  SearchNewsViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 03/09/2022.
//

import UIKit
import CoreData

protocol SearchNewsViewControllerDelegate {
    func refreshNewsFeed(searchQuery: String)
}

class SearchNewsViewController: UIViewController {
    
    var savedHistory = [SearchHistory]()
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var delegate: SearchNewsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        loadData()
        print(savedHistory)
    }
    
    func loadData() {
        let request: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        do {
            if let result = try managedObjectContext?.fetch(request) {
                savedHistory = result
                self.searchTableView.reloadData()
            }
        } catch {
            print("Error in loading core data items.")
        }
    }
    
    func saveData() {
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error saving items to core data.")
        }
        loadData()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        let searchItem = searchTextField.text
        if searchItem != "" {
            let searchEntryExists = checkIfExists(textFieldInput: searchItem!)
            switch searchEntryExists {
            case true:
                delegate?.refreshNewsFeed(searchQuery: searchItem!)
                self.dismiss(animated: true, completion: nil)
            case false:
                if let entity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: self.managedObjectContext!) {
                    let history = NSManagedObject(entity: entity, insertInto: self.managedObjectContext)
                    history.setValue(searchItem, forKey: "searchItem")
                }
            }
            self.saveData()
            
            delegate?.refreshNewsFeed(searchQuery: searchItem!)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func clearAllHistoryButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Clear History", message: "Clear all search history?", preferredStyle: .alert)
        let addClearButton = UIAlertAction(title: "Clear", style: .destructive) { action in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try self.managedObjectContext?.execute(batchDeleteRequest)
            } catch {
                print("Error clearing all saved items.")
            }
            self.saveData()
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(addClearButton)
        alertController.addAction(cancelButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func checkIfExists(textFieldInput: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchHistory")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "searchItem == %@", textFieldInput)
        
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
}

// MARK: - TableViewDelegate, TableViewDataSource
extension SearchNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        let historyList = savedHistory[indexPath.row]
        cell.textLabel?.text = historyList.value(forKey: "searchItem") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            managedObjectContext?.delete(savedHistory[indexPath.row])
        }
        saveData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchAgain = savedHistory[indexPath.row]
        let one = searchAgain.value(forKey: "searchItem")
        delegate?.refreshNewsFeed(searchQuery: one as! String)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
