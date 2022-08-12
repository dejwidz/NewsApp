//
//  UserChoiceModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/07/2022.
//

import Foundation

protocol UserChoiceModelProtocol: AnyObject {
    var delegate: UserChoiceModelDelegate? {get set}
    func getUserChoiceArticles()
}

protocol UserChoiceModelDelegate: AnyObject {
    func userChoiceArticlesHasBeenDownloaded(_ userChoiceModel: UserChoiceModelProtocol, articles: [UserChoiceArticle])
}

final class UserChoiceModel: UserChoiceModelProtocol {
    weak var delegate: UserChoiceModelDelegate?
    
    init(){}
    
    func getUserChoiceArticles() {
        let articlesToReturn = DataStorage.shared.getUserChoiceArticles()
        delegate?.userChoiceArticlesHasBeenDownloaded(self, articles: articlesToReturn)
    }
}
