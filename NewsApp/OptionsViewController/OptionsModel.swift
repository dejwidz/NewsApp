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
    func fromDateHasChanged(fromDate: String)
}

protocol OptionsModelDelegate: AnyObject {
    
    
}


final class OptionsModel {
    var delegate: OptionsModelDelegate?
    
    
}

extension OptionsModel: OptionsModelProtocol {
    func fromDateHasChanged(fromDate: String) {
        URLBuilder.shared.setDateFrom(newDateFrom: fromDate)
    }
    
    func toDateHasChanged(toDate: String) {
        URLBuilder.shared.setDateTo(newDateTo: toDate)
    }
    
    
}
