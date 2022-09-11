//
//  ViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 01/09/2022.
//

import UIKit
import SDWebImage
import CoreLocation

class NewsFeedViewController: UIViewController {
    
    var articles: [Article] = []
    var weatherManager = WeatherManager()
    var newsManager = NewsManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner()
        self.title = "General"
        self.tabBarItem.title = "General"
        newsManager.getTopStories { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tblView.reloadData()
                //self.removeSpinner()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
        
        weatherManager.weatherDelegate = self
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
        cell.newsImageView.sd_setImage(with: URL(string: item.urlToImage ?? "noImage"))
        cell.authorlabel.text = item.source?.name
        cell.descriptionLabel.text = item.title
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "DetailNewsViewController") as? DetailNewsViewController else {return}
        let item = articles[indexPath.row]
        newsDetailVC.item = item
        newsDetailVC.isFromViewController = "NewsFeed"
        show(newsDetailVC, sender: self)
    }
}

// MARK: - SearchNewsViewControllerDelegate
extension NewsFeedViewController: SearchNewsViewControllerDelegate {
    
    func refreshNewsFeed(searchQuery: String) {
        self.showSpinner()
        newsManager.searchNews(searchQuery: searchQuery) { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.removeSpinner()
                if articles.count == 0 {
                    self.tblView.setEmptyView(title: "No search results..", messageImage: UIImage(named: "lupaBB")!, message: "Your search query '\(searchQuery)' did not return any results!")
                } else {
                    self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                }
            }
        }
        self.title = searchQuery.capitalized
        self.tabBarItem.title = searchQuery.capitalized
    }
}

// MARK: - NewsCategoryViewControllerDelegate
extension NewsFeedViewController: NewsCategoryViewControllerDelegate {
    func refreshNewsFeed(category: String) {
        self.showSpinner()
        newsManager.searchNews(category: category) { articles in
            self.articles = articles
            DispatchQueue.main.async {
                self.tblView.reloadData()
                self.removeSpinner()
                self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
            }
        }
        self.title = category
        self.tabBarItem.title = category
    }
}

// MARK: - WeatherManagerDelegate
extension NewsFeedViewController: WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = ("\(weather.temperatureString)°C\n\(weather.cityName)")
            self.weatherImageView.image = UIImage(named: weather.conditionName)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension NewsFeedViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeatherByLocation(lattitude: lat, longitude: lon)
            self.removeSpinner()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



