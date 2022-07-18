//
//  News.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 16/07/2022.
//

import Foundation


struct News: Codable {
    
    var status: String?
    var totalResults: Int?
    var articles: [Article]?
}
