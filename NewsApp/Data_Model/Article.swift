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
}
