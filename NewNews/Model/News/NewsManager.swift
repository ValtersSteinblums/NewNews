//
//  NewsManager.swift
//  NewNews
//
//  Created by valters.steinblums on 02/09/2022.
//

import Foundation

class NewsManager {
    static let shared = NewsManager()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?apiKey=5ae2470e968e40c99c3819b7d42f7d94&country=us")
        static let searchEverythingURL = "https://newsapi.org/v2/everything?apiKey=5ae2470e968e40c99c3819b7d42f7d94&q="
        static let searchByCategoryURL = "https://newsapi.org/v2/top-headlines?apiKey=5ae2470e968e40c99c3819b7d42f7d94&country=us&category="
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping([Article]) -> ()) {
        guard let url = Constants.topHeadlinesURL else {return}
        sessionTask(url: url, completion: completion)
    }
    
    public func searchNews(searchQuery: String, completion: @escaping([Article]) -> ()) {
        let urlString = Constants.searchEverythingURL + searchQuery
        guard let url = URL(string: urlString) else {return}
        sessionTask(url: url, completion: completion)
    }
    
    public func searchNews(category: String, completion: @escaping([Article]) -> ()) {
        let urlString = Constants.searchByCategoryURL + category
        guard let url = URL(string: urlString) else {return}
        sessionTask(url: url, completion: completion)
    }
    
    func sessionTask(url: URL, completion: @escaping([Article]) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print((error?.localizedDescription)!)
                return
            }
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            do {
                let jsonData = try JSONDecoder().decode(NewsData.self, from: data)
                completion(jsonData.articles ?? [])
            } catch {
                print("ERROR:::", error)
            }
        }
        task.resume()
    }
}
