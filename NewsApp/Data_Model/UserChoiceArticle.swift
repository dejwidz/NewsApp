//
//  UserChoiceArticle.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 01/08/2022.
//

import Foundation
import RealmSwift

final class UserChoiceArticle: Object {
    
    @Persisted private var author: String?
    @Persisted private var title: String?
    @Persisted private var descriptionn: String?
    @Persisted private var url: String?
    @Persisted private var urlToImage: String?
    @Persisted private var publishedAt: String?
    @Persisted private var content: String?
    
    override init() {}
    
    init(newArticle: Article) {
        self.author = newArticle.author
        self.title = newArticle.title
        self.descriptionn = newArticle.description
        self.url = newArticle.url
        self.urlToImage = newArticle.urlToImage
        self.publishedAt = newArticle.publishedAt
        self.content = newArticle.content
    }
}
