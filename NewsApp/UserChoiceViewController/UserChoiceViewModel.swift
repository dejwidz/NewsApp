//
//  UserChoiceViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/07/2022.
//

import Foundation

protocol UserChoiceViewModelProtocol: AnyObject {
    var delegate: UserChoiceViewModelDelegate? {get set}
    func getUserChoiceArticlesFromModel()
}

protocol UserChoiceViewModelDelegate: AnyObject {
    func userChoiceArticlesHasBeenDownloaded(_ userchoiceViewModel: UserChoiceViewModelProtocol, articles: [UserChoiceArticle])
}

final class UserChoiceViewModel: UserChoiceViewModelProtocol {
    weak var delegate: UserChoiceViewModelDelegate?
    private var model: UserChoiceModel
    
    init(model: UserChoiceModel) {
        self.model = model
        model.delegate = self
    }
    
    func getUserChoiceArticlesFromModel() {
        model.getUserChoiceArticles()
    }
    
}

extension UserChoiceViewModel: UserChoiceModelDelegate {
    func userChoiceArticlesHasBeenDownloaded(_ userChoiceModel: UserChoiceModelProtocol, articles: [UserChoiceArticle]) {
        delegate?.userChoiceArticlesHasBeenDownloaded(self, articles: articles)
    }
}
