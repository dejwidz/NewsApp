//
//  ViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import Foundation

protocol NewsViewModelProtocol: AnyObject {
    var delegate: NewsViewModelDelegate? {get set}
    func getArticlesToDisplay()
    func searchTextHasChanged(newText: String)
    func setWeatherIndicator(weatherIndicator: Bool)
}

protocol NewsViewModelDelegate: AnyObject {
    func articlesHasBeenDownloaded(_ newsViewModel: NewsViewModelProtocol, articles: [Article])
}

final class NewsViewModel: NewsViewModelProtocol {
    
    weak var delegate: NewsViewModelDelegate?
    private var model: NewsModelProtocol
    
    init(model: NewsModelProtocol) {
        self.model = model
        model.delegate = self
    }
    
    func getArticlesToDisplay() {
        model.sendStoredArticles()
        model.getArticlesFromWeb()
    }
    
    func searchTextHasChanged(newText: String) {
        let stringPreparedToMakeQuery = prepareStringToMakeQuery(stringToPrepare: newText)
        guard stringPreparedToMakeQuery != "" else {
            model.sendStoredArticles()
            model.setNewQuery(newQuery: "")
            model.getArticlesFromWeb()
            return
        }
        model.setNewQuery(newQuery: stringPreparedToMakeQuery)
        model.getArticlesFromWeb()
    }
    
    private func prepareStringToMakeQuery(stringToPrepare: String) -> String {
        var tempString = stringToPrepare.lowercased()
        let prohibitSet = CharacterSet(charactersIn: " -_=+!@#$%^&*();.>,</?")
        tempString = tempString.trimmingCharacters(in: prohibitSet)
        tempString = tempString.replacingOccurrences(of: " ", with: "-")
        return tempString
    }
    
    func setWeatherIndicator(weatherIndicator: Bool) {
        model.setWeatherIndicator(weatherIndicator: weatherIndicator)
    }
    
}

extension NewsViewModel: NewsModelDelegate {
    func latestArticlesHasBeenSent(_ newsModel: NewsModelProtocol, articles: [Article]) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
    }
    
    func articlesHasBeenDownloaded(_ newsModel: NewsModelProtocol, articles: [Article]) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
    }
    
    func errorWhileDownloadingArticles(_ newsModel: NewsModelProtocol) {
        model.sendStoredArticles()
    }
}

