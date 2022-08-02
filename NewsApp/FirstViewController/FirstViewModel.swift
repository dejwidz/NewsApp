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
        model.getAriclesFromWeb()
    }
    
}

extension FirstViewModel: FirstModelDelegate {
    func articlesHasBeenDownloaded(_ firstModel: FirstModelProtocol, articles: [Article]) {
        print("_________--_______--_________ SUCCES VM")
        delegate?.articlesHasBeenDownloaded(self, articles: articles)
//        DataStorage.shared.setLatestArticles(newArticles: articles)
    }
    
    func errorWhileDownloadingArticles(_ firstModel: FirstModelProtocol) {
        
    }
    
    
}

