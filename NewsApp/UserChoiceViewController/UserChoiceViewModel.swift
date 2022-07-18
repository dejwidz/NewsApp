//
//  UserChoiceViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/07/2022.
//

import Foundation

protocol UserChoiceViewModelProtocol: AnyObject {
    var delegate: UserChoiceViewModelDelegate? {get set}
}

protocol UserChoiceViewModelDelegate: AnyObject {
    
}

final class UserChoiceViewModel: UserChoiceViewModelProtocol {
    var delegate: UserChoiceViewModelDelegate?
    
    
    private var model: UserChoiceModel
    
    init(model: UserChoiceModel) {
        self.model = model
        model.delegate = self
    }
    
}

extension UserChoiceViewModel: UserChoiceModelDelegate {
    
}
