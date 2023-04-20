//
//  Model.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import Foundation
import RealmSwift
import CoreLocation


protocol NewsModelProtocol: AnyObject {
    var delegate: NewsModelDelegate? {get set}
    func getArticlesFromWeb()
    func sendStoredArticles()
    func setNewQuery(newQuery: String)
    func setWeatherIndicator(weatherIndicator: Bool)
    func setFirstLocation()
}

protocol NewsModelDelegate: AnyObject {
    func articlesHasBeenDownloaded(_ newsModel: NewsModelProtocol?, articles: [Article]?)
    func latestArticlesHasBeenSent(_ newsModel: NewsModelProtocol, articles: [Article])
    func errorWhileDownloadingArticles(_ newsModel: NewsModelProtocol)
}

final class NewsModel: NewsModelProtocol {
    
    weak var delegate: NewsModelDelegate?
    private var netDataSupplier: NetDataSupplier?
    private var urlManager: URLManager?
    private var latestArticleManager: LatestArticlesManager?
    private var locationManager: LocationManager?
    
    init(netDataSupplier: NetDataSupplier, urlManager: URLManager, latestArticleManager: LatestArticlesManager, locationManager: LocationManager) {
        self.netDataSupplier = netDataSupplier
        self.urlManager = urlManager
        self.latestArticleManager = latestArticleManager
        self.locationManager = locationManager
    }
    
    func getArticlesFromWeb() {
        netDataSupplier?.getDataFromWeb(typename: News(), completion: {[weak self] result in
            switch result {
            case .success(let news):
                self?.delegate?.articlesHasBeenDownloaded(self, articles: news.articles)
                if news.articles!.count >= 20 {
                    self?.latestArticleManager?.setLatestArticles(latestArticles: news.articles ?? [])
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
        urlManager?.setQuery(newQuery: newQuery)
    }
    
    func setWeatherIndicator(weatherIndicator: Bool) {
        urlManager?.setWeatherIndicator(newWeatherIndicator: weatherIndicator)
    }
    
    func setFirstLocation() {
        locationManager?.setFirstLocation(CLLocation.init(latitude: +37.78583400, longitude: -122.40641700))
    }
}
