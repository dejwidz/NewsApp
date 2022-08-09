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
        model.getArticlesWithQuery()
    }
    
    func prepareStringToMakeQuery(stringToPrepare: String) -> String {
        var tempString = stringToPrepare.lowercased()
        let prohibitSet = CharacterSet(charactersIn: " -_=+!@#$%^&*();.>,</?")
        tempString = tempString.trimmingCharacters(in: prohibitSet)
        tempString = tempString.replacingOccurrences(of: " ", with: "-")
        return tempString
    }
    
}

extension FirstViewModel: FirstModelDelegate {
    func latestArticlesHasBeenSent(_ firstModel: FirstModelProtocol, articles: [Article]) {
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
        //        print("VM Error -> latest articles*******************************************")
    }
    
    func articlesHasBeenDownloaded(_ firstModel: FirstModelProtocol, articles: [Article]) {
        //        print("_________--_______--_________ SUCCES VM")
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
        //        DataStorage.shared.setLatestArticles(newArticles: articles)
    }
    
    func errorWhileDownloadingArticles(_ firstModel: FirstModelProtocol) {
        model.sendStoredArticles()
    }
    
    
}

