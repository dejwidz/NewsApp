//
//  Model.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import Foundation
import RealmSwift


protocol FirstModelProtocol: AnyObject {
    var delegate: FirstModelDelegate? {get set}
    func getAriclesFromWeb()
    func sendStoredArticles()
    func getArticlesWithQuery()
    func setNewQuery(newQuery: String)
}

protocol FirstModelDelegate: AnyObject {
    func articlesHasBeenDownloaded(_ firstModel: FirstModelProtocol, articles: [Article])
    func latestArticlesHasBeenSent(_ firstModel: FirstModelProtocol, articles: [Article])
    func errorWhileDownloadingArticles(_ firstModel: FirstModelProtocol)
}

final class FirstModel: FirstModelProtocol {
    
    
      
    weak var delegate: FirstModelDelegate?
    
    
    init() {
        
    }
    
    func getAriclesFromWeb() {
//        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^%%^^^^^^")
        NetworkingServices.networkSingleton.getArticlesWithAlamo(completion: {[weak self] result in
            switch result {
                
            case .success(let news):
//                print("------------------------------ SUCCES")
                self!.delegate?.articlesHasBeenDownloaded(self!, articles: news.articles!)
                if news.articles!.count >= 20 {
                    DataStorage.shared.setLatestArticles(latestArticles: news.articles!)
                }
            case .failure(let error):
                self!.delegate?.errorWhileDownloadingArticles(self!)
                print(error.localizedDescription, "odjaniepawliło się")
            }
        })
    }
    
    func getArticlesWithQuery() {
        NetworkingServices.networkSingleton.getArticlesWithSearch(completion: {[weak self] result in
            switch result {
                
            case .success(let news):
//                print("------------------------------ SUCCES")
                self!.delegate?.articlesHasBeenDownloaded(self!, articles: news.articles!)
                if news.articles!.count >= 20 {
                    DataStorage.shared.setLatestArticles(latestArticles: news.articles!)
                }
            case .failure(let error):
                self!.delegate?.errorWhileDownloadingArticles(self!)
                print(error.localizedDescription, "odjaniepawliło się")
            }
        })
    }
    
    func sendStoredArticles() {
        let articlesToSend = DataStorage.shared.getLatestArticles()
        delegate?.latestArticlesHasBeenSent(self, articles: articlesToSend)
    }
   
    func setNewQuery(newQuery: String) {
        URLBuilder.shared.setQuery(newQuery: newQuery)
    }

}
