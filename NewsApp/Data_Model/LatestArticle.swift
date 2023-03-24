//
//  LatestArticle.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 01/08/2022.
//

import Foundation
import RealmSwift
import UIKit

final class LatestArticle: Object {
    
    @Persisted var author: String?
    @Persisted var title: String?
    @Persisted var descriptionn: String?
    @Persisted var url: String?
    @Persisted var urlToImage: String?
    @Persisted var publishedAt: String?
    @Persisted var content: String?
    
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
