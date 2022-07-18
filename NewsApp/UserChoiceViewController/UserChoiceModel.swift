//
//  UserChoiceModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/07/2022.
//

import Foundation

protocol UserChoiceModelProtocol: AnyObject {
    var delegate: UserChoiceModelDelegate? {get set}
}

protocol UserChoiceModelDelegate: AnyObject {
    
}

final class UserChoiceModel: UserChoiceModelProtocol {
    var delegate: UserChoiceModelDelegate?
    
    init(){
        
    }
    
}
