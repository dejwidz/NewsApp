//
//  Model.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import Foundation
import RealmSwift


protocol NewsModelProtocol: AnyObject {
    var delegate: NewsModelDelegate? {get set}
    func getArticlesFromWeb()
    func sendStoredArticles()
    func setNewQuery(newQuery: String)
    func setWeatherIndicator(weatherIndicator: Bool)
}

protocol NewsModelDelegate: AnyObject {
    func articlesHasBeenDownloaded(_ newsModel: NewsModelProtocol, articles: [Article])
    func latestArticlesHasBeenSent(_ newsModel: NewsModelProtocol, articles: [Article])
    func errorWhileDownloadingArticles(_ newsModel: NewsModelProtocol)
}

final class NewsModel: NewsModelProtocol {
    weak var delegate: NewsModelDelegate?
    
    init() {}
    
    func getArticlesFromWeb() {
        NetworkingServices.shared.getDataFromWeb(typename: News(), completion: {[weak self] result in
            switch result {
            case .success(let news):
                self!.delegate?.articlesHasBeenDownloaded(self!, articles: news.articles!)
                if news.articles!.count >= 20 {
                    DataStorage.shared.setLatestArticles(latestArticles: news.articles!)
                }
            case .failure(let error):
                self!.delegate?.errorWhileDownloadingArticles(self!)
                print(error.localizedDescription)
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
    
    func setWeatherIndicator(weatherIndicator: Bool) {
        URLBuilder.shared.setWeatherIndicator(newWeatherIndicator: weatherIndicator)
    }
}
