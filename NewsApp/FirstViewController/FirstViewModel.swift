//
//  ViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import Foundation

protocol FirstViewModelProtocol: AnyObject {
    var delegate: FirstViewModeleDelegate? {get set}
    func getArticlesToDisplay()
    func searchTextHasChanged(newText: String)
    func setWeatherIndicator(weatherIndicator: Bool)
}

protocol FirstViewModeleDelegate: AnyObject {
    func articlesHasBeenDownloaded(_ firstViewModel: FirstViewModelProtocol, articles: [Article])
}

final class FirstViewModel: FirstViewModelProtocol {

    
    weak var delegate: FirstViewModeleDelegate?
    private var model: FirstModelProtocol
    
    init(model: FirstModelProtocol) {
        self.model = model
        model.delegate = self
    }
    
    func getArticlesToDisplay() {
        model.sendStoredArticles()
        model.getAriclesFromWeb()
    }
    
    func searchTextHasChanged(newText: String) {
        let stringPreparedToMakeQuery = prepareStringToMakeQuery(stringToPrepare: newText)
        guard stringPreparedToMakeQuery != "" else {
            model.sendStoredArticles()
            model.setNewQuery(newQuery: "")
            model.getAriclesFromWeb()
            return
        }
        model.setNewQuery(newQuery: stringPreparedToMakeQuery)
        model.getAriclesFromWeb()
    }
    
    func prepareStringToMakeQuery(stringToPrepare: String) -> String {
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

extension FirstViewModel: FirstModelDelegate {
    func latestArticlesHasBeenSent(_ firstModel: FirstModelProtocol, articles: [Article]) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
    }
    
    func articlesHasBeenDownloaded(_ firstModel: FirstModelProtocol, articles: [Article]) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
    }
    
    func errorWhileDownloadingArticles(_ firstModel: FirstModelProtocol) {
        model.sendStoredArticles()
    }
}

