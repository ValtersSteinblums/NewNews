//
//  NewsManager.swift
//  NewNews
//
//  Created by valters.steinblums on 02/09/2022.
//

import Foundation

struct NewsManager {
    
    let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?apiKey=5ae2470e968e40c99c3819b7d42f7d94&country=us")
    let searchEverythingURL = "https://newsapi.org/v2/everything?apiKey=5ae2470e968e40c99c3819b7d42f7d94&q="
    let searchByCategoryURL = "https://newsapi.org/v2/top-headlines?apiKey=5ae2470e968e40c99c3819b7d42f7d94&country=us&category="
    
    func getTopStories(completion: @escaping([Article]) -> ()) {
        guard let url = topHeadlinesURL else {return}
        sessionTask(url: url, completion: completion)
    }
    
    func searchNews(searchQuery: String, completion: @escaping([Article]) -> ()) {
        let urlString = searchEverythingURL + searchQuery
        guard let url = URL(string: urlString) else {return}
        sessionTask(url: url, completion: completion)
    }
    
    func searchNews(category: String, completion: @escaping([Article]) -> ()) {
        let urlString = searchByCategoryURL + category
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
