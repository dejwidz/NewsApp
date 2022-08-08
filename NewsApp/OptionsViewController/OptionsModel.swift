//
//  OptionsModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 07/08/2022.
//

import Foundation

protocol OptionsModelProtocol: AnyObject {
    var delegate: OptionsModelDelegate? {get set}
    func toDateHasChanged(toDate: String)
    func fromDateHasChanged(toDate: String)
}

protocol OptionsModelDelegate: AnyObject {
    
    
}


final class OptionsModel {
    var delegate: OptionsModelDelegate?
    
    
}

extension OptionsModel: OptionsModelProtocol {
    func fromDateHasChanged(toDate: String) {
        
    }
    
    func toDateHasChanged(toDate: String) {
        
    }
    
    
}
