//
//  NewsData.swift
//  NewNews
//
//  Created by valters.steinblums on 02/09/2022.
//

import Foundation

// MARK: - NewsItem
struct NewsData: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author: String?
    let title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
//    let id: ID?
    let id: String?
    let name: String?
}

//enum ID: String, Codable {
//    case arsTechnica = "ars-technica"
//    case bbcNews = "bbc-news"
//    case cnn = "cnn"
//    case engadget = "engadget"
//    case reuters = "reuters"
//    case theVerge = "the-verge"
//    case wired = "wired"
//}
