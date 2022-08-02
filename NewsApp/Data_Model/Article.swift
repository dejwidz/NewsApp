//
//  Article.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 16/07/2022.
//

import Foundation

struct Article: Codable {
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    init() {}
    
    init(newArticle: UserChoiceArticle) {
        self.author = newArticle.author
        self.title = newArticle.title
        self.description = newArticle.descriptionn
        self.url = newArticle.url
        self.urlToImage = newArticle.urlToImage
        self.publishedAt = newArticle.publishedAt
        self.content = newArticle.content
    }
    
    init(newArticle: LatestArticle) {
        self.author = newArticle.author
        self.title = newArticle.title
        self.description = newArticle.descriptionn
        self.url = newArticle.url
        self.urlToImage = newArticle.urlToImage
        self.publishedAt = newArticle.publishedAt
        self.content = newArticle.content
    }
    
    
    
}
