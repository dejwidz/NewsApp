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
    func setFirsLocation()
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
    
    func setFirsLocation() {
        model.setFirstLocation()
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
//        let prohibitSet = CharacterSet(charactersIn: " -_=+!@#$%^&*();.>,</?")
//        tempString = tempString.trimmingCharacters(in: prohibitSet)
        tempString = tempString.replacingOccurrences(of: " ", with: "-")
        tempString.unicodeScalars.removeAll(where: { !CharacterSet.urlUserAllowed.contains($0) })
    print("ZAPYTANIE  ",tempString)
        return tempString
    }
    
    func setWeatherIndicator(weatherIndicator: Bool) {
        model.setWeatherIndicator(weatherIndicator: weatherIndicator)
    }
}

//MARK: - model Delegate extension

extension NewsViewModel: NewsModelDelegate {
    func latestArticlesHasBeenSent(_ newsModel: NewsModelProtocol, articles: [Article]) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
    }
    
    func articlesHasBeenDownloaded(_ newsModel: NewsModelProtocol?, articles: [Article]?) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles ?? [])
    }
    
    func errorWhileDownloadingArticles(_ newsModel: NewsModelProtocol) {
        model.sendStoredArticles()
    }
}

